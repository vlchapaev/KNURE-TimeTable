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

	let coreDataSource: CoreDataSource
	let remoteSource: RemoteSource
	let timetableParser: TimetableParser

	init(coreDataSource: CoreDataSource,
		 remoteSource: RemoteSource,
		 timetableParser: TimetableParser) {
		self.coreDataSource = coreDataSource
		self.remoteSource = remoteSource
		self.timetableParser = timetableParser
	}

	func localSelectedItems() -> Observable<[Item]> {
		let request = NSFetchRequest<ItemManaged>(entityName: "ItemManaged")
		return coreDataSource.observe(request).map { $0.map({ $0.domainValue }) }
	}

	func localSaveItem(item: Item) -> Promise<Void> {
		return coreDataSource.save { context in
			let itemManaged = ItemManaged(context: context)
			itemManaged.identifier = item.identifier
			itemManaged.fullName = item.fullName
			itemManaged.title = item.shortName
			itemManaged.lastUpdateTimestamp = item.lastUpdate?.timeIntervalSince1970 as NSNumber?
		}
	}

    func localRemoveItem(identifier: String) -> Promise<Void> {
		let request = NSFetchRequest<ItemManaged>(entityName: "ItemManaged")
		request.predicate = NSPredicate(format: "identifier = %@", identifier)
		return coreDataSource.delete(request)
    }

	func remoteItems(ofType: TimetableItem) -> Promise<NetworkResponse> {
		let address = "http://cist.nure.ua/ias/app/tt/"
		guard let url = URL(string: address) else {
			return Promise(error: NetworkingError.invalidUrlError)
		}

		let request = NetworkRequest(url: url)
		return remoteSource.execute(request)
	}

}
