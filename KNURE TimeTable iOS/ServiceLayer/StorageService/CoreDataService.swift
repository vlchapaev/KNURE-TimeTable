//
//  CoreDataService.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 24/03/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import CoreData
import Combine

/// Basic CoreData service
protocol CoreDataService: ReactiveCoreDataService {

	/// <#Description#>
	/// - Parameters:
	///   - request: <#request description#>
	///   - convert: <#convert description#>
	func fetch<T, R>(_ request: NSFetchRequest<T>, _ convert: (T) -> R?) -> [R]

	/// <#Description#>
	/// - Parameter request: <#request description#>
	func delete<T: NSManagedObject>(_ request: NSFetchRequest<T>)

	/// <#Description#>
	/// - Parameter request: <#request description#>
	func save(_ request: NSBatchInsertRequest)
}

/// CoreData service based on Reactive approach
protocol ReactiveCoreDataService {

	/// Observable for request
	///
	/// - Parameter request: NSFetchRequest
	/// - Returns: Observable fetch result
	func observe<T, R>(_ request: NSFetchRequest<T>) -> AnyPublisher<[R], Error>
		where T: NSFetchRequestResult & Convertable, R == T.NewType
}
