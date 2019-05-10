//
//  PromisedCoreDataSource.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 24/03/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import CoreData
import PromiseKit

class PromisedCoreDataSource: CoreDataSource {

	let coreDataService: CoreDataService

	init(coreDataService: CoreDataService) {
		self.coreDataService = coreDataService
	}

	func fetch<T>(_ request: NSFetchRequest<T>) -> Guarantee<[T]> {
		return Guarantee(resolver: { seal in

			var result: [T] = []
			let context = self.coreDataService.parentContext

			do {
				// swiftlint:disable:next force_cast
				let fetchResult = try context.fetch(request) as! T
				result.append(fetchResult)

			} catch {
				print("\(#file) \(#function) \(error)")
			}

			seal(result)
		})
	}

	func delete<T>(_ request: NSFetchRequest<T>) -> Promise<Void> {
		return Promise(resolver: { seal in
			let context = self.coreDataService.parentContext
			do {
				// swiftlint:disable:next force_cast
				let objects: [NSManagedObject] = try context.fetch(request) as! [NSManagedObject]
				objects.forEach { context.delete($0) }
				try context.save()
				seal.fulfill(())
			} catch {
				seal.reject(error)
			}
		})
	}

	func save(_ context: (NSManagedObjectContext) -> Void) -> Promise<Void> {
		return Promise(resolver: { seal in
			let backgroundContext = self.coreDataService.parentContext
			backgroundContext.performAndWait {
				do {
					context(backgroundContext)
					try backgroundContext.save()
					seal.fulfill(())
				} catch {
					seal.reject(error)
				}
			}
		})
	}
}
