//
//  EntityObserver.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 04/06/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import CoreData
import RxSwift

final class EntityObserver<T: NSFetchRequestResult>: NSObject, NSFetchedResultsControllerDelegate {
	typealias Observer = AnyObserver<[T]>

	private let observer: Observer
	private let disposeBag: DisposeBag
	private let frc: NSFetchedResultsController<T>

	init(observer: Observer,
		 fetchRequest: NSFetchRequest<T>,
		 context: NSManagedObjectContext,
		 sectionNameKeyPath: String?,
		 cacheName: String?) {

		self.observer = observer
		disposeBag = DisposeBag()

		self.frc = NSFetchedResultsController(fetchRequest: fetchRequest,
											  managedObjectContext: context,
											  sectionNameKeyPath: sectionNameKeyPath,
											  cacheName: cacheName)

		super.init()

		context.perform {
			self.frc.delegate = self

			do {
				try self.frc.performFetch()
			} catch {
				observer.on(.error(error))
			}

			self.sendNextElement()
		}
	}

	private func sendNextElement() {
		frc.managedObjectContext.perform {
			let entities = self.frc.fetchedObjects ?? []
			self.observer.on(.next(entities))
		}
	}

	public func controllerDidChangeContent(_ : NSFetchedResultsController<NSFetchRequestResult>) {
		sendNextElement()
	}
}

extension EntityObserver: Disposable {
	public func dispose() {
		frc.delegate = nil
	}
}
