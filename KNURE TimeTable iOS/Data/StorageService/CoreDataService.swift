//
//  CoreDataService.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 17/03/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import Foundation
import CoreData

class CoreDataService {

	let persistentStoreCoordinator: NSPersistentStoreCoordinator

	let mainContext: NSManagedObjectContext
	let parentContext: NSManagedObjectContext

	init() {
		persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: NSManagedObjectModel())

		parentContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
		parentContext.mergePolicy = NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType
		parentContext.persistentStoreCoordinator = persistentStoreCoordinator

		mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		mainContext.mergePolicy = NSMergePolicyType.mergeByPropertyStoreTrumpMergePolicyType
		mainContext.parent = parentContext
	}

	private func storeURL() throws -> URL {
		guard let applicationName = Bundle.main.bundleIdentifier?.components(separatedBy: ".").last else {
			throw ApplicationNotFoundError()
		}

		var path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.applicationSupportDirectory,
													   FileManager.SearchPathDomainMask.userDomainMask,
													   true).last!

		path.append(String(format: "/%@", applicationName))
		path.append(String(format: "/%@.sqlite", applicationName))
		let url = URL(fileURLWithPath: path, isDirectory: false)
		return url
	}

	func openPersistentStore(_ coordinator: NSPersistentStoreCoordinator) throws {

		let storeUrl = try storeURL()

		try FileManager.default.createDirectory(at: storeUrl.deletingLastPathComponent(),
												withIntermediateDirectories: true,
												attributes: nil)

		let options: [String: Any] = [
			NSMigratePersistentStoresAutomaticallyOption: true,
			NSInferMappingModelAutomaticallyOption: true,
			NSSQLitePragmasOption: ["journal_mode": "WAL"],
			]

		try _ = coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
											   configurationName: nil,
											   at: storeUrl,
											   options: options)
	}
}

class ApplicationNotFoundError: Error { }
