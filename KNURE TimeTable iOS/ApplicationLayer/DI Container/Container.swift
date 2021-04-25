//
//  Container.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 25/04/2021.
//  Copyright © 2021 Vladislav Chapaev. All rights reserved.
//

struct Container {

	let storage: Storage = .init()

	static var shared: Container = .init()

	func resolve<T>(_ dependency: T.Type = T.self, named name: String? = nil) throws -> T {
		let key = Key(object: ObjectIdentifier(dependency), name: name)
		guard let component = try storage.get(for: key) as? Component<T> else { throw Errors.noDependencyFor(key) }
		return try component.make(with: self)
	}

	func register<T>(_ dependency: T.Type = T.self,
					 named name: String? = nil,
					 in scope: Scope = .unique,
					 _ factory: @escaping (Container) throws -> T) rethrows {
		let key = Key(object: ObjectIdentifier(dependency), name: name)
		let resolver = Component(factory: factory, scope: scope, wrapper: scope.wrapper)
		storage.append(entry: resolver, for: key)
	}

	enum Errors: Error {
		case noDependencyFor(Key)
	}
}

extension Container {
	struct Key: Hashable {
		let object: ObjectIdentifier
		let name: String?
	}
}

extension Container {
	final class Storage {

		private var storage: [Key: Any] = [:]

		var count: Int {
			storage.values.count
		}

		func append(entry: Any, for key: Key) {
			storage[key] = entry
		}

		func get(for key: Key) throws -> Any {
			guard let value = storage[key] else { throw Errors.noDependencyFor(key) }
			return value
		}

		func destroy() {
			storage.removeAll()
		}
	}
}

extension Container {
	final class Component<T> {
		let factory: (Container) throws -> T
		let scope: Scope
		var wrapper: Instance?

		init(factory: @escaping (Container) throws -> T, scope: Scope, wrapper: Instance? = nil) {
			self.factory = factory
			self.scope = scope
			self.wrapper = wrapper
		}

		func make(with container: Container) throws -> T {
			switch scope {
				case .unique:
					return try factory(container)

				case .graph, .shared:
					if let instance = wrapper?.instance as? T {
						return instance
					} else {
						let instance = try factory(container)
						defer { wrapper?.instance = instance }
						return instance
				}
			}
		}
	}
}

extension Container {
	enum Scope {
		case unique
		case graph
		case shared

		var wrapper: Instance? {
			switch self {
				case .unique: return nil
				case .graph: return Graph()
				case .shared: return Shared()
			}
		}
	}
}

extension Container.Scope {
	final class Graph: Instance {

		var instance: Any? {
			get { return entity }
			set { entity = newValue as AnyObject }
		}

		weak var entity: AnyObject?
	}

	final class Shared: Instance {
		var instance: Any?
	}
}

protocol Instance {
	var instance: Any? { get set }
}
