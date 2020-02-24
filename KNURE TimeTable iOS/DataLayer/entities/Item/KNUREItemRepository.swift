//
//  KNUREItemRepository.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import CoreData
import RxSwift

final class KNUREItemRepository: ItemRepository {

	private let coreDataService: CoreDataService
	private let reactiveCoreDataService: ReactiveCoreDataService
	private let reactiveNetworkingService: ReactiveNetworkService
	private let importService: ImportService

	init(coreDataService: CoreDataService,
		 reactiveCoreDataService: ReactiveCoreDataService,
		 reactiveNetworkingService: ReactiveNetworkService,
		 importService: ImportService) {
		self.coreDataService = coreDataService
		self.reactiveCoreDataService = reactiveCoreDataService
		self.reactiveNetworkingService = reactiveNetworkingService
		self.importService = importService
	}

	func localItems() -> [Item] {
		let request = NSFetchRequest<ItemManaged>(entityName: "ItemManaged")
		request.predicate = NSPredicate(value: true)
		request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
		return coreDataService.fetch(request).map { $0.newValue }
	}

	func localItems(type: TimetableItem) -> [Item] {
		let request = NSFetchRequest<ItemManaged>(entityName: "ItemManaged")
		request.predicate = NSPredicate(format: "type = %@", NSNumber(value: type.rawValue))
		request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
		return coreDataService.fetch(request).map { $0.newValue }
	}

	func localSelectedItems() -> Observable<[Item]> {
		let request = NSFetchRequest<ItemManaged>(entityName: "ItemManaged")
		request.predicate = NSPredicate(format: "selected = %@", NSNumber(value: true))
		request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
		return reactiveCoreDataService.observe(request).map {
			$0.map { $0.newValue }
		}
	}

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

	func remoteItems(type: TimetableItem) -> Observable<[Item]> {
		let request: NetworkRequest
		do {
			request = try KNURERequestBuilder.make(endpoint: .item(type))
		} catch {
			return Observable.error(error)
		}
		return Observable.of(reactiveNetworkingService.execute(request))
			.flatMap { $0 }
			.map {
				try self.importService.importData($0.data,
												  transform: { $0["type"] = type.rawValue },
												  completion: { })
			}.map { self.localItems(type: type) }
	}
}
