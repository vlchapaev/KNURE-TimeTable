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
	private let timetableParser: TimetableParser

	init(promisedCoreDataService: PromisedCoreDataService,
		 reactiveCoreDataService: ReactiveCoreDataService,
		 promisedNetworkingService: PromisedNetworkService,
		 timetableParser: TimetableParser) {
		self.promisedCoreDataService = promisedCoreDataService
		self.reactiveCoreDataService = reactiveCoreDataService
		self.promisedNetworkingService = promisedNetworkingService
		self.timetableParser = timetableParser
	}

	func localSelectedItems() -> Observable<[Item]> {
		let request = NSFetchRequest<ItemManaged>(entityName: "ItemManaged")
		return reactiveCoreDataService.observe(request).map { $0.map({ $0.domainValue }) }
	}

	func localSaveItem(item: Item) -> Promise<Void> {
		return promisedCoreDataService.save { context in
			let itemManaged = ItemManaged(context: context)
			itemManaged.identifier = item.identifier
			itemManaged.fullName = item.fullName
			itemManaged.title = item.shortName
			itemManaged.lastUpdateTimestamp = item.lastUpdate?.timeIntervalSince1970 as NSNumber?
		}
	}

    func localDeleteItem(identifier: String) -> Promise<Void> {
		let request = NSFetchRequest<ItemManaged>(entityName: "ItemManaged")
		request.predicate = NSPredicate(format: "identifier = %@", identifier)
		return promisedCoreDataService.delete(request)
    }

	func remoteItems(ofType: TimetableItem) -> Promise<NetworkResponse> {
		let address = "http://cist.nure.ua/ias/app/tt/"
		guard let url = URL(string: address) else {
			return Promise(error: Networking.invalidUrlError)
		}

		let request = NetworkRequest(url: url)
		return promisedNetworkingService.execute(request)
	}

}
