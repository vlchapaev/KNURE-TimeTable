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
		return Promise { seal in
			self.persistentContainer.performBackgroundTask { context in
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

	func save(_ context: @escaping (NSManagedObjectContext) -> Void) -> Promise<Void> {
		return Promise { seal in
			self.persistentContainer.performBackgroundTask { backgroundContext in
				do {
					context(backgroundContext)
					try backgroundContext.save()
					seal.fulfill(())
				} catch {
					seal.reject(error)
				}
			}
		}
	}
}
