//
//  KNURELessonImportService.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 08/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import CoreData

final class KNURELessonImportService {

	private let persistentContainer: NSPersistentContainer

	init(persistentContainer: NSPersistentContainer) {
		self.persistentContainer = persistentContainer
	}
}

extension KNURELessonImportService: ImportService {

	func decode(_ data: Data, appending parameters: [String: Any]) throws {
		let response = try JSONDecoder().decode(KNURE.Response.Lesson.self, from: data)
		persistentContainer.performBackgroundTask { context in
			let helper: Helper = .init(groups: response.groups,
									   teachers: response.teachers,
									   subjects: response.subjects,
									   types: response.types)
			let entries = response.events.map {
				self.transform($0, helper: helper)
			}

			do {
//				let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LessonManaged")
//				request.predicate = NSPredicate(format: "itemIdentifier = %@", <#T##args: CVarArg...##CVarArg#>)
//				let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
//				try context.execute(deleteRequest)

				let insertRequest = NSBatchInsertRequest(entity: LessonManaged.entity(), objects: entries)
				insertRequest.resultType = NSBatchInsertRequestResultType.objectIDs
				let result = try context.execute(insertRequest) as? NSBatchInsertResult
				if let objectIDs = result?.result as? [NSManagedObjectID], !objectIDs.isEmpty {
					NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSInsertedObjectsKey: objectIDs],
														into: [context])
				}
			} catch {
				print(error)
			}
		}
	}

	private func transform(_ event: KNURE.Response.Lesson.Event,
						   helper: Helper) -> [String: Any] {
		var result: [String: Any] = [:]
		if let subject = helper.subjects.first(where: { $0.id == event.subject_id }) {
			result["brief"] = subject.brief
			result["title"] = subject.title
		}

		if let type = helper.types.first(where: { $0.id == event.type }) {
			result["typeBrief"] = type.short_name
			result["typeTitle"] = type.full_name
			result["type"] = type.id_base
		}

		result["event"] = Int64(event.number_pair)
		result["auditory"] = event.auditory
		result["startTimestamp"] = event.start_time
		result["endTimestamp"] = event.end_time

		let teachers = helper.teachers
			.filter { event.teachers.contains($0.id) }
			.map { ["identifier": "\($0.id)", "title": $0.short_name, "fullName": $0.full_name, "type": 2] }

		let groups = helper.groups
			.filter { event.groups.contains($0.id) }
			.map { ["identifier": "\($0.id)", "title": $0.name, "type": 1] }

		result["items"] = groups + teachers

		return result
	}

	struct Helper {
		let groups: [KNURE.Response.University.Faculty.Direction.Group]
		let teachers: [KNURE.Response.University.Faculty.Department.Teacher]
		let subjects: [KNURE.Response.Lesson.Subject]
		let types: [KNURE.Response.Lesson.`Type`]
	}
}
