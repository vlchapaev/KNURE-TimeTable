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
	
	func fetch<T>(_ request: NSFetchRequest<NSFetchRequestResult>) -> Guarantee<[T]> {
		return Guarantee(resolver: { [weak self] seal in
			guard let __self = self else { return }
			
			var result: [T] = []
			let context = __self.coreDataService.parentContext
			
			do {
				let fetchResult = try context.fetch(request) as! T
				result.append(fetchResult)
				
			} catch {
				print("\(#file) \(#function) \(error)")
			}
			
			seal(result)
		})
	}
	
	func delete(_ request: NSFetchRequest<NSFetchRequestResult>) -> Promise<Void> {
		return Promise.value(())
	}
}
