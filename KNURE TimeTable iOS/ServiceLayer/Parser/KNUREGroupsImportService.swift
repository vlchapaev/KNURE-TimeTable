//
//  KNUREGroupsImportService.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 08/08/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import CoreData

final class KNUREGroupsImportService {

	private let persistentContainer: NSPersistentContainer

	init(persistentContainer: NSPersistentContainer) {
		self.persistentContainer = persistentContainer
	}

}

extension KNUREGroupsImportService: ImportService {

	func decode(_ data: Data) throws {
		let response = try JSONDecoder().decode(KNURE.Response.self, from: data)
		persistentContainer.performBackgroundTask { context in
			let entries = response.university.faculties
				.flatMap { $0.directions }
				.flatMap { $0.groups }
				.map(self.transfrom)

			do {
				let request = NSBatchInsertRequest(entity: ItemManaged.entity(), objects: entries)
				request.resultType = NSBatchInsertRequestResultType.objectIDs
				let insertResult = try context.execute(request) as? NSBatchInsertResult
				if let objectIDs = insertResult?.result as? [NSManagedObjectID], !objectIDs.isEmpty {
					NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSInsertedObjectsKey: objectIDs],
														into: [context])
				}
			} catch {
				print(error)
			}
		}
	}

	// MARK: - Private

	private func transfrom(_ group: KNURE.Response.University.Faculty.Direction.Group) -> [String: Any] {
		return [
			"identifier": String(group.id),
			"title": group.name,
			"type": 1
		]
	}
}
