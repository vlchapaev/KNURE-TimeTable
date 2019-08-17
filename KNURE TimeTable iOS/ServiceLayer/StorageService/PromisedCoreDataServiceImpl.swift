//
//  PromisedCoreDataServiceImpl.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 24/03/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import CoreData
import PromiseKit

class PromisedCoreDataServiceImpl: PromisedCoreDataService {

	private let persistentContainer: NSPersistentContainer

	init(persistentContainer: NSPersistentContainer) {
		self.persistentContainer = persistentContainer
	}

	func fetch<T>(_ request: NSFetchRequest<T>) -> Guarantee<[T]> where T: NSFetchRequestResult {
		let context = persistentContainer.viewContext
		return fetch(request, in: context)
	}

	func fetch<T>(_ request: NSFetchRequest<T>,
				  in context: NSManagedObjectContext) -> Guarantee<[T]> where T: NSFetchRequestResult {
		return Guarantee { seal in
			context.performAndWait {
				var result: [T] = []

				do {
					result = try context.fetch(request)
				} catch {
					seal([])
				}

				seal(result)
			}
		}
	}

	func delete<T>(_ request: NSFetchRequest<T>) -> Promise<Void> where T: NSManagedObject {
		return Promise { [weak self] seal in
			self?.persistentContainer.performBackgroundTask { context in
				do {
					let objects = try context.fetch(request)
					objects.forEach { context.delete($0) }
					try context.save()
					seal.fulfill(())
				} catch {
					seal.reject(error)
				}
			}
		}
	}

	func update(_ request: NSBatchUpdateRequest) -> Promise<Void> {
		return Promise { [weak self] seal in
			self?.persistentContainer.performBackgroundTask { context in
				do {
					try context.execute(request)
					seal.fulfill(())
				} catch {
					seal.reject(error)
				}
			}
		}
	}
}
