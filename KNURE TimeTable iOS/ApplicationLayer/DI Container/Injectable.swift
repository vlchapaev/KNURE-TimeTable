//
//  Injectable.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 25/04/2021.
//  Copyright © 2021 Vladislav Chapaev. All rights reserved.
//

@propertyWrapper
struct Injectable<T> {

	private let container: Container
	private let name: String?

	var wrappedValue: T {
		guard let instance = try? container.resolve(T.self, named: name) else {
			fatalError("Unable to resolve dependency: \(T.Type.self)")
		}
		return instance
	}

	init(container: Container = .shared, name: String? = nil) {
		self.container = container
		self.name = name
	}
}
