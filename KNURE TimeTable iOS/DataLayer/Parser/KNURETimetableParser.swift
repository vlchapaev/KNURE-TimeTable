//
//  KNURETimetableParser.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 08/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import Foundation

class KNURETimetableParser: TimetableParser {

	let coreDataService: CoreDataService

	init(coreDataService: CoreDataService) {
		self.coreDataService = coreDataService
	}

	func parseTimetable(itemId: NSNumber, data: Data, _ completion: () -> Void) throws {
		let utfEncodedData = try data.transform(from: .windowsCP1251, to: .utf8)
		let json = try JSONSerialization.jsonObject(with: utfEncodedData, options: [])

		guard let dictionary = json as? [AnyHashable: Any] else {
			throw KNURETimeTableParseError.dataCastError
		}

		guard let events = dictionary["events"] as? [[AnyHashable: Any]] else {
			throw KNURETimeTableParseError.eventsCastError
		}

//		guard let groups = dictionary["gropus"] as? [[AnyHashable: Any]] else {
//			throw KNURETimeTableParseError.groupsCastError
//		}
//
//		guard let teachers = dictionary["teachers"] as? [[AnyHashable: Any]] else {
//			throw KNURETimeTableParseError.teachersCastError
//		}

		guard let types = dictionary["types"] as? [[AnyHashable: Any]] else {
			throw KNURETimeTableParseError.typesCastError
		}

		guard let subjects = dictionary["subjects"] as? [[AnyHashable: Any]] else {
			throw KNURETimeTableParseError.subjectsCastError
		}

		let context = coreDataService.mainContext

		context.performAndWait {

			for event in events {
				let lesson = LessonManaged(context: context)
				lesson.itemIdentifier = itemId
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
			}
		}

		try context.save()
		completion()
	}

	func parseItemList(data: Data, _ completion: () -> Void) throws {
	}

}

enum KNURETimeTableParseError: Error {
	case dataCastError
	case eventsCastError
	case groupsCastError
	case teachersCastError
	case typesCastError
	case subjectsCastError
}
