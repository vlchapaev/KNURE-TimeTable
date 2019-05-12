//
//  UpdateTimetableUseCase.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 12/05/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import PromiseKit

class UpdateTimetableUseCase: UseCase {

	typealias Query = NSNumber
	typealias Response = Void

	let lessonRepository: LessonRepository

	init(lessonRepository: LessonRepository) {
		self.lessonRepository = lessonRepository
	}

	func execute(_ query: NSNumber) -> Promise<Void> {
		return lessonRepository.remoteLoadTimetable(itemId: query)
	}
}
