//
//  UpdateTimetableUseCase.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 12/05/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import PromiseKit

class UpdateTimetableUseCase: UseCase {

	typealias Query = String
	typealias Response = Promise<Void>

	let lessonRepository: LessonRepository

	init(lessonRepository: LessonRepository) {
		self.lessonRepository = lessonRepository
	}

	func execute(_ query: String) -> Promise<Void> {
		return lessonRepository.remoteLoadTimetable(identifier: query)
	}
}
