//
//  KNURETeachersImportService.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 08/11/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import CoreData

final class KNURETeachersImportService {

	private let persistentContainer: NSPersistentContainer

	init(persistentContainer: NSPersistentContainer) {
		self.persistentContainer = persistentContainer
	}
}

extension KNURETeachersImportService: ImportService {

	func decode(_ data: Data) throws {
		let response = try JSONDecoder().decode(KNURE.Response.self, from: data)
		persistentContainer.performBackgroundTask { context in
			let entries = response.university.faculties
				.flatMap { $0.departments }
				.flatMap { $0.teachers }
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

	private func transform(_ teacher: KNURE.Response.University.Faculty.Department.Teacher) -> [String: Any] {
		return [
			"identifier": String(teacher.id),
			"title": teacher.short_name,
			"fullName": teacher.full_name,
			"type": 2
		]
	}
}
