//
//  CoreDataServiceImpl.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 24/03/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import CoreData

final class CoreDataServiceImpl: CoreDataService {

	private let persistentContainer: NSPersistentContainer

	init(persistentContainer: NSPersistentContainer) {
		self.persistentContainer = persistentContainer
	}

	func fetch<T>(_ request: NSFetchRequest<T>) -> [T] where T: NSFetchRequestResult {
		let context = persistentContainer.viewContext
		return fetch(request, in: context)
	}

	func fetch<T>(_ request: NSFetchRequest<T>,
				  in context: NSManagedObjectContext) -> [T] where T: NSFetchRequestResult {
		var result: [T] = []
		context.performAndWait {
			do {
				result = try context.fetch(request)
			} catch {
				print(error)
			}
		}
		return result
	}
}
