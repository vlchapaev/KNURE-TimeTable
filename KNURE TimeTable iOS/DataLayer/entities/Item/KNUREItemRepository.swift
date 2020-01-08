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

	func localItems() -> Observable<[Item]> {
		let request = NSFetchRequest<ItemManaged>(entityName: "ItemManaged")
		request.predicate = NSPredicate(value: true)
		return reactiveCoreDataService.observe(request).map {
			$0.map { $0.domainValue }
		}
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

	func localSearchItems(query: String) {
		// TODO: implement
	}
//
//	func remoteUpdateItems(type: TimetableItem) -> Promise<Void> {
//		var address: String = "http://cist.nure.ua/ias/app/tt/"
//		switch type {
//		case .group:
//			address += "P_API_GROUP_JSON"
//
//		case .teacher:
//			address += "P_API_PODR_JSON"
//
//		case .auditory:
//			address += "P_API_AUDITORIES_JSON"
//		}
//
//		guard let url = URL(string: address) else {
//			return Promise(error: DataLayerError.invalidUrlError)
//		}
//
//		return Promise { seal in
//			let request = NetworkRequest(url: url)
//			reactiveNetworkingService.execute(request)
//				.done { [weak self] response in
//					try self?.importService.importData(response.data,
//													   transform: { $0["type"] = type.rawValue },
//													   completion: { seal.fulfill(()) })
//				}.catch { seal.reject($0) }
//		}
//	}
}
