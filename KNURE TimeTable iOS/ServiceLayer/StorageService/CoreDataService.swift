//
//  CoreDataService.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 24/03/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import CoreData
import RxSwift

protocol CoreDataService {

	func fetch<T>(_ request: NSFetchRequest<T>) -> [T]

	func fetch<T>(_ request: NSFetchRequest<T>, in context: NSManagedObjectContext) -> [T]
}

/// CoreData service based on Reactive approach
protocol ReactiveCoreDataService {

	/// Observable for request
	///
	/// - Parameter request: NSFetchRequest
	/// - Returns: Observable fetch result
	func observe<T>(_ request: NSFetchRequest<T>) -> Observable<[T]>

	func update(_ request: NSBatchUpdateRequest) -> Single<Void>
}
