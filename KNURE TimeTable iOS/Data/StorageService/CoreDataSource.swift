//
//  CoreDataSource.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 24/03/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import CoreData
import PromiseKit

protocol CoreDataSource {
	func fetch<T>(_ request: NSFetchRequest<NSFetchRequestResult>) -> Guarantee<[T]>
	func delete(_ request: NSFetchRequest<NSFetchRequestResult>) -> Promise<Void>
	func save(_ context: (NSManagedObjectContext) -> Void) -> Promise<Void>
}
