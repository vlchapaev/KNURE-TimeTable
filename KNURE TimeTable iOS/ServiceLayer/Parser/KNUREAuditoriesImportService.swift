//
//  KNUREAuditoriesImportService.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 08/11/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import CoreData

final class KNUREAuditoriesImportService {

	private let persistentContainer: NSPersistentContainer

	init(persistentContainer: NSPersistentContainer) {
		self.persistentContainer = persistentContainer
	}
}

extension KNUREAuditoriesImportService: ImportService {
	func decode(_ data: Data) throws {
		let response = try JSONDecoder().decode(KNURE.Response.self, from: data)
		persistentContainer.performBackgroundTask { context in
			let entries = response.university.buildings
				.flatMap { $0.auditories }
				.map(self.transform)

			do {
				let request = NSBatchInsertRequest(entity: ItemManaged.entity(), objects: entries)
				request.resultType = NSBatchInsertRequestResultType.objectIDs
				let result = try context.execute(request) as? NSBatchInsertResult
				if let objectIDs = result?.result as? [NSManagedObjectID], !objectIDs.isEmpty {
					NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSInsertedObjectsKey: objectIDs],
														into: [context])
				}
			} catch {
				print(error)
			}
		}
	}

	// MARK: - Private

	private func transform(_ auditory: KNURE.Response.University.Building.Auditory) -> [String: Any] {
		return [
			"identifier": auditory.id,
			"title": auditory.short_name,
			"type": 3
		]
	}
}
