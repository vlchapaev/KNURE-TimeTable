//
//  UpdateTimetableUseCase.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 12/05/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//


final class UpdateTimetableUseCase: UseCase<String, Void> {

	private let lessonRepository: LessonRepository

	init(lessonRepository: LessonRepository) {
		self.lessonRepository = lessonRepository
	}

	// MARK: - UseCase

	override func execute(_ query: String) {
//		return lessonRepository.remoteLoadTimetable(identifier: query)
	}
}
