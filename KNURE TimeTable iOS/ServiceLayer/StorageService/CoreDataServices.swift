//
//  CoreDataServices.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 24/03/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import CoreData
import PromiseKit
import RxSwift

protocol PromisedCoreDataService {
	func fetch<T>(_ request: NSFetchRequest<T>) -> Guarantee<[T]>
	func fetch<T>(_ request: NSFetchRequest<T>, in context: NSManagedObjectContext) -> Guarantee<[T]>
	func delete<T>(_ request: NSFetchRequest<T>) -> Promise<Void> where T: NSManagedObject
	func save(_ context: @escaping (NSManagedObjectContext) -> Void) -> Promise<Void>
}

protocol ReactiveCoreDataService {
	func observe<T>(_ request: NSFetchRequest<T>) -> Observable<[T]>
}
