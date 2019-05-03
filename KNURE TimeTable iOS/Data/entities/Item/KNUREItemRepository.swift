//
//  KNUREItemRepository.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import PromiseKit
import CoreData

class KNUREItemRepository: ItemRepository {

	let coreDataSource: CoreDataSource
	let remoteSource: RemoteSource

	init(coreDataSource: CoreDataSource,
		 remoteSource: RemoteSource) {
		self.coreDataSource = coreDataSource
		self.remoteSource = remoteSource
	}

    func localSelectedItems() -> Promise<[Item]> {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemManaged")
        return Promise(coreDataSource.fetch(request))
    }

    func localSaveItem(item: Item) -> Promise<Void> {
		return coreDataSource.save { context in
			// TODO: make ItemManaged instance
			// TODO: map domain to data
		}
	}

    func localRemoveItem(identifier: String) -> Promise<Void> {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemManaged")
		request.predicate = NSPredicate(format: "identifier = %@", identifier)
		return coreDataSource.delete(request)
    }

	func remoteItems(ofType: TimetableItem) -> Promise<[Item]> {
		return Promise(resolver: { seal in
			let address = "http://cist.nure.ua/ias/app/tt/"
			guard let url = URL(string: address) else {
				seal.reject(InvalidUrlError())
				return
			}

			let request = NetworkRequest(url: url)
			remoteSource.execute(request)
		})
    }

}
