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

/// CoreData service based on Promises
protocol PromisedCoreDataService {

	/// Give a promise to fetch CoreData with request
	///
	/// - Parameter request: NSFetchRequest
	/// - Returns: a promise to be fulfilled
	func fetch<T>(_ request: NSFetchRequest<T>) -> Guarantee<[T]>

	/// Give a promise to fetch CoreData with request in context
	///
	/// - Parameters:
	///   - request: NSFetchRequest
	///   - context: NSManagedObjectContext
	/// - Returns: a promise to be fulfilled
	func fetch<T>(_ request: NSFetchRequest<T>, in context: NSManagedObjectContext) -> Guarantee<[T]>

	/// Give a promise to delete objects
	///
	/// - Parameter request: NSFetchRequest
	/// - Returns: promise of finished operation
	func delete<T>(_ request: NSFetchRequest<T>) -> Promise<Void> where T: NSManagedObject

	/// Give a promise to perform batch update for request
	///
	/// - Parameter request: batch update request
	/// - Returns: promise of finished operation
	func update(_ request: NSBatchUpdateRequest) -> Promise<Void>
}

/// CoreData service based on Reactive approach
protocol ReactiveCoreDataService {

	/// Observable for request
	///
	/// - Parameter request: NSFetchRequest
	/// - Returns: Observable fetch result
	func observe<T>(_ request: NSFetchRequest<T>) -> Observable<[T]>
}
