//
//  KNURELessonImportService.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 08/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import CoreData

final class KNURELessonImportService: ImportService {

	private let persistentContainer: NSPersistentContainer

	init(persistentContainer: NSPersistentContainer) {
		self.persistentContainer = persistentContainer
	}

	// MARK: - ImportService

	func importData(_ data: Data?, _ completion: () -> Void) throws {
		try importData(data, transform: { _ in }, completion: completion)
	}

	func importData(_ data: Data?,
					transform: @escaping (inout [AnyHashable: Any]) -> Void,
					completion: () -> Void) throws {

		guard let data = data else { throw ImportServiceError.nilData }

		let utfEncodedData = try data.transform(from: .windowsCP1251, to: .utf8)
		let json = try JSONSerialization.jsonObject(with: utfEncodedData,
													options: [.mutableLeaves, .allowFragments, .mutableContainers])

		guard var dictionary = json as? [AnyHashable: Any] else { throw ImportServiceError.nilData }

		transform(&dictionary)

		guard let identifier = dictionary["identifier"] as? String else {
			throw ImportServiceError.missing("identifier")
		}

		guard let events = dictionary["events"] as? [[AnyHashable: Any]] else {
			throw ImportServiceError.missing("events")
		}

		guard let groups = dictionary["gropus"] as? [[AnyHashable: Any]] else {
			throw ImportServiceError.missing("gropus")
		}

		guard let teachers = dictionary["teachers"] as? [[AnyHashable: Any]] else {
			throw ImportServiceError.missing("teachers")
		}

		guard let types = dictionary["types"] as? [[AnyHashable: Any]] else {
			throw ImportServiceError.missing("types")
		}

		guard let subjects = dictionary["subjects"] as? [[AnyHashable: Any]] else {
			throw ImportServiceError.missing("subjects")
		}

		let context = persistentContainer.newBackgroundContext()

		let fetchRequest: NSFetchRequest<NSFetchRequestResult> = LessonManaged.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "itemIdentifier = %@", identifier)
		let request = NSBatchDeleteRequest(fetchRequest: fetchRequest)
		try persistentContainer.persistentStoreCoordinator.execute(request, with: context)

		context.performAndWait {
			for event in events {
				let lesson = LessonManaged(context: context)
				lesson.itemIdentifier = identifier
				lesson.auditory = event["auditory"] as? String
				lesson.numberPair = event["number_pair"] as? NSNumber
				lesson.startTimestamp = event["start_time"] as? NSNumber
				lesson.endTimestamp = event["end_time"] as? NSNumber

				let subjectId = event["subject_id"] as? NSNumber
				lesson.subjectIdentifier = subjectId
				lesson.brief = subjects.first(where: { $0["id"] as? NSNumber == subjectId })?["brief"] as? String
				lesson.title = subjects.first(where: { $0["id"] as? NSNumber == subjectId })?["title"] as? String

				let type = event["type"] as? NSNumber
				lesson.type = type
				lesson.typeBrief = types.first(where: { $0["id"] as? NSNumber == type })?["short_name"] as? String
				lesson.typeTitle = types.first(where: { $0["id"] as? NSNumber == type })?["full_name"] as? String

				// TODO: Parse
				lesson.teachers = teachers as NSObject
				lesson.groups = groups as NSObject
			}
		}

		try context.save()
		completion()
	}
}
