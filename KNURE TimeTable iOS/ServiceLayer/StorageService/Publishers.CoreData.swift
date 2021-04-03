//
//  Publishers.CoreData.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 28/07/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import Combine
import CoreData

extension Publishers {

	final class CoreData<T: NSFetchRequestResult & Convertable>: NSObject, NSFetchedResultsControllerDelegate {

		private let fetchResultsController: NSFetchedResultsController<T>
		private let context: NSManagedObjectContext
		private let subject: CurrentValueSubject<[T.NewType], Failure>

		init(request: NSFetchRequest<T>,
			 context: NSManagedObjectContext,
			 sectionNameKeyPath: String? = nil,
			 cacheName: String? = nil) {

			self.context = context
			subject = .init([])
			fetchResultsController = NSFetchedResultsController(fetchRequest: request,
																managedObjectContext: context,
																sectionNameKeyPath: sectionNameKeyPath,
																cacheName: cacheName)

			super.init()

			fetchResultsController.delegate = self
		}

		// MARK: - NSFetchedResultsControllerDelegate

		func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
			context.perform { [weak self] in
				guard let self = self else { return }
				guard let objects = controller.fetchedObjects as? [T] else { return self.subject.send([]) }
				let result = objects.compactMap { $0.convert() }
				self.subject.send(result)
			}
		}

	}
}

extension Publishers.CoreData: Publisher {

	typealias Output = [T.NewType]
	typealias Failure = Never

	func receive<S>(subscriber: S) where S: Subscriber,
		Publishers.CoreData<T>.Failure == S.Failure,
		Publishers.CoreData<T>.Output == S.Input {

			context.perform { [weak self] in
				guard let self = self else { return }
				try? self.fetchResultsController.performFetch()

				guard let objects = self.fetchResultsController.fetchedObjects else { return self.subject.send([]) }
				let result = objects.compactMap { $0.convert() }
				self.subject.send(result)
			}
	}
}
