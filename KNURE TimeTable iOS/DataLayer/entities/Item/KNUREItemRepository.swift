//
//  KNUREItemRepository.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import CoreData
import RxSwift

class KNUREItemRepository: ItemRepository {

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
		return coreDataService.fetch(request).map { $0.domainValue }
	}

	func localItems(type: TimetableItem) -> [Item] {
		let request = NSFetchRequest<ItemManaged>(entityName: "ItemManaged")
		request.predicate = NSPredicate(format: "type = %@", type.rawValue)
		return coreDataService.fetch(request).map { $0.domainValue }
	}

	func localSelectedItems() -> Observable<[Item]> {
		let request = NSFetchRequest<ItemManaged>(entityName: "ItemManaged")
		request.predicate = NSPredicate(format: "selected = %@", true)
		return reactiveCoreDataService.observe(request).map {
			$0.map { $0.domainValue }
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
		var address: String = "http://cist.nure.ua/ias/app/tt/"
		switch type {
		case .group:
			address += "P_API_GROUP_JSON"

		case .teacher:
			address += "P_API_PODR_JSON"

		case .auditory:
			address += "P_API_AUDITORIES_JSON"
		}

		let request = NetworkRequest(url: URL(string: address)!)

		return Observable<[Item]>.create { observer in
			self.reactiveNetworkingService.execute(request).subscribe {
				do {
					try self.importService.importData($0.element?.data,
													  transform: { $0["type"] = type.rawValue },
													  completion: {
														observer.onNext(self.localItems(type: type))
														observer.onCompleted()
					})
				} catch {
					observer.onNext(self.localItems(type: type))
					observer.onCompleted()
				}
			}
		}
	}
}
