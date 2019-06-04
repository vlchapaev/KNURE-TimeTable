//
//  NSManagedObjectContext+Reactive.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 04/06/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import RxSwift
import CoreData

extension Reactive where Base: NSManagedObjectContext {
	func entities<T: NSFetchRequestResult>(fetchRequest: NSFetchRequest<T>,
										   sectionNameKeyPath: String? = nil,
										   cacheName: String? = nil) -> Observable<[T]> {
		return Observable.create { observer in
			let observerAdapter = EntityObserver(observer: observer,
												 fetchRequest: fetchRequest,
												 context: self.base,
												 sectionNameKeyPath: sectionNameKeyPath,
												 cacheName: cacheName)
			return Disposables.create {
				observerAdapter.dispose()
			}
		}
	}

	func save() -> Observable<Void> {
		return Observable.create { observer in
			do {
				try self.base.save()
				observer.onNext(())
			} catch {
				observer.onError(error)
			}
			return Disposables.create()
		}
	}
}
