//
//  KNUREItemRepository.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import PromiseKit
import CoreData
import RxSwift

class KNUREItemRepository: ItemRepository {

	private let promisedCoreDataService: PromisedCoreDataService
	private let reactiveCoreDataService: ReactiveCoreDataService
	private let promisedNetworkingService: PromisedNetworkService
	private let importService: ImportService

	init(promisedCoreDataService: PromisedCoreDataService,
		 reactiveCoreDataService: ReactiveCoreDataService,
		 promisedNetworkingService: PromisedNetworkService,
		 importService: ImportService) {
		self.promisedCoreDataService = promisedCoreDataService
		self.reactiveCoreDataService = reactiveCoreDataService
		self.promisedNetworkingService = promisedNetworkingService
		self.importService = importService
	}

	func localSelectedItems() -> Observable<[Item]> {
		let request = NSFetchRequest<ItemManaged>(entityName: "ItemManaged")
		request.predicate = NSPredicate(format: "selected = %@", true)
		return reactiveCoreDataService.observe(request).map {
			$0.map { $0.domainValue }
		}
	}

	func localSaveItem(identifier: String) -> Promise<Void> {
		let request = NSBatchUpdateRequest(entityName: "ItemManaged")
		request.predicate = NSPredicate(format: "identifier = %@", identifier)
		request.propertiesToUpdate = ["selected": true]
		return promisedCoreDataService.update(request)
	}

    func localDeleteItem(identifier: String) -> Promise<Void> {
		let itemRequest = NSBatchUpdateRequest(entityName: "ItemManaged")
		itemRequest.predicate = NSPredicate(format: "identifier = %@", identifier)
		itemRequest.propertiesToUpdate = ["selected": false]

		let lessonRequest = NSFetchRequest<LessonManaged>(entityName: "LessonManaged")
		lessonRequest.predicate = NSPredicate(format: "itemIdentifier = %@", identifier)

		return promisedCoreDataService.update(itemRequest).then {
			self.promisedCoreDataService.delete(lessonRequest)
		}
    }

	func remoteUpdateItems(ofType: TimetableItem) -> Promise<Void> {
		let address = "http://cist.nure.ua/ias/app/tt/"
		guard let url = URL(string: address) else {
			return Promise(error: DataLayerError.invalidUrlError)
		}

		let request = NetworkRequest(url: url)
		return promisedNetworkingService.execute(request).asVoid()
	}

}
