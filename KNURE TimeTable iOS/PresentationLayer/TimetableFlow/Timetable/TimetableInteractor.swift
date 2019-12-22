//
//  TimetableInteractor.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 22/12/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

protocol TimetableInteractorInput {
	func updateTimetable(identifier: String)
}

protocol TimetableInteractorOutput: AnyObject {
}

final class TimetableInteractor: TimetableInteractorInput {

	weak var output: TimetableInteractorOutput?

	private let updateTimetableUseCase: UpdateTimetableUseCase

	init(updateTimetableUseCase: UpdateTimetableUseCase) {
		self.updateTimetableUseCase = updateTimetableUseCase
	}

	// MARK: - TimetableInteractorInput

	func updateTimetable(identifier: String) {
		_ = updateTimetableUseCase.execute(identifier)
	}
}
