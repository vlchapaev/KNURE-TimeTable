//
//  CDPublisher.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 28/07/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import Combine
import CoreData

final class CDPublisher<T: NSFetchRequestResult & Convertable>: NSObject,
	Publisher,
NSFetchedResultsControllerDelegate {

	typealias Output = [T.NewType]
	typealias Failure = Never

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

	// MARK: - Publisher

	func receive<S>(subscriber: S) where S: Subscriber,
		CDPublisher.Failure == S.Failure,
		CDPublisher.Output == S.Input {

			context.perform { [weak self] in
				guard let self = self else { return }
				try? self.fetchResultsController.performFetch()

				guard let objects = self.fetchResultsController.fetchedObjects else { return self.subject.send([]) }
				let result = objects.compactMap { $0.newValue }
				self.subject.send(result)
			}
	}

	// MARK: - NSFetchedResultsControllerDelegate

	private func controllerDidChangeContent(_ controller: NSFetchedResultsController<T>) {
		context.perform { [weak self] in
			guard let self = self else { return }
			guard let objects = self.fetchResultsController.fetchedObjects else { return self.subject.send([]) }
			let result = objects.compactMap { $0.newValue }
			self.subject.send(result)
		}
    }
}
