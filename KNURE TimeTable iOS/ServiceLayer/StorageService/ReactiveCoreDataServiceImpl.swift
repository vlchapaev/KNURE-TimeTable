//
//  ReactiveCoreDataServiceImpl.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 05/07/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import RxSwift
import CoreData

class ReactiveCoreDataServiceImpl: ReactiveCoreDataService {

	private let persistentContainer: NSPersistentContainer

	init(persistentContainer: NSPersistentContainer) {
		self.persistentContainer = persistentContainer
	}

	func observe<T>(_ request: NSFetchRequest<T>) -> Observable<[T]> where T: NSFetchRequestResult {
		let context = persistentContainer.viewContext
		let scheduler = ContextScheduler(context: context)
		return context.rx.entities(fetchRequest: request).subscribeOn(scheduler)
	}
}
