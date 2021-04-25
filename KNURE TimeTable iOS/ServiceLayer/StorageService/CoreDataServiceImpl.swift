//
//  CoreDataServiceImpl.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 24/03/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import CoreData
import Combine

final class CoreDataServiceImpl {

	private let persistentContainer: NSPersistentContainer

	init(persistentContainer: NSPersistentContainer) {
		self.persistentContainer = persistentContainer
	}
}

extension CoreDataServiceImpl: CoreDataService {

	func fetch<T, R>(_ request: NSFetchRequest<T>,
					 _ convert: (T) -> R?) -> [R] where T: NSFetchRequestResult {
		let context = persistentContainer.viewContext
		var result: [R] = []
		context.performAndWait {
			do {
				result = try context.fetch(request).compactMap { convert($0) }
			} catch {
				print(error)
			}
		}
		return result
	}
}

extension CoreDataServiceImpl: ReactiveCoreDataService {

	func observe<T, R>(_ request: NSFetchRequest<T>) -> AnyPublisher<[R], Error>
		where T: NSFetchRequestResult & Convertable, R == T.NewType {
			let context = persistentContainer.viewContext
			let publisher = Publishers.CoreData(request: request, context: context)
			return AnyPublisher(publisher)
	}
}
