//
//  KNUREItemRepository.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import CoreData
import Combine

final class KNUREItemRepository: ItemRepository {

	private let coreDataService: CoreDataService
	private let networkService: NetworkService

	init(coreDataService: CoreDataService,
		 networkService: NetworkService) {
		self.coreDataService = coreDataService
		self.networkService = networkService
	}

	func localItems() -> [Item] {
		let request: NSFetchRequest<ItemManaged> = ItemManaged.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
		return coreDataService.fetch(request) { $0.convert() }
	}

	func local(items type: Item.Kind) -> [Item] {
		let request: NSFetchRequest<ItemManaged> = ItemManaged.fetchRequest()
		request.predicate = NSPredicate(format: "type = %@", NSNumber(value: type.rawValue))
		request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
		return coreDataService.fetch(request) { $0.convert() }
	}

//	func localSelectedItems() -> AnyPublisher<[Item], Never> {
//		let request = NSFetchRequest<ItemManaged>(entityName: "ItemManaged")
//		request.predicate = NSPredicate(format: "selected = %@", NSNumber(value: true))
//		request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//		return coreDataService.observe(request)
//	}

//	func localSaveItem(identifier: String) -> Promise<Void> {
//		let request = NSBatchUpdateRequest(entityName: "ItemManaged")
//		request.predicate = NSPredicate(format: "identifier = %@", identifier)
//		request.propertiesToUpdate = ["selected": true]
//		return coreDataService.update(request)
//	}
//
//    func localDeleteItem(identifier: String) -> Promise<Void> {
//		let itemRequest = NSBatchUpdateRequest(entityName: "ItemManaged")
//		itemRequest.predicate = NSPredicate(format: "identifier = %@", identifier)
//		itemRequest.propertiesToUpdate = ["selected": false]
//
//		let lessonRequest = NSFetchRequest<LessonManaged>(entityName: "LessonManaged")
//		lessonRequest.predicate = NSPredicate(format: "itemIdentifier = %@", identifier)
//
//		return coreDataService.update(itemRequest).then {
//			self.coreDataService.delete(lessonRequest)
//		}
//    }

	func remote(items type: Item.Kind) -> AnyPublisher<[Item], Error> {
		let request: URLRequest
		do {
			request = try KNURE.Request.make(endpoint: .item(type))
		} catch {
			return Fail(error: error).eraseToAnyPublisher()
		}

		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		return networkService.execute(request)
			.tryMap { element -> Data in
				guard element.status == .ok else { throw element.status }
				return element.data
		}
		.decode(type: KNURE.Response.self, decoder: decoder)
		.map {
			switch type {
				case .group:
					return $0.university.groups
				case .teacher:
					return $0.university.teachers
				case .auditory:
					return $0.university.auditories
			}
		}
		.eraseToAnyPublisher()
	}
}
