//
//  TimetableAssembly.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 22/12/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

struct TimetableAssembly: Assembly {

	func assemble(container: Container) throws {
		try container.register(TimetableViewController.self) {
			let interactor = try $0.resolve(TimetableInteractor.self)
			let controller = TimetableViewController()

			controller.interactor = interactor
			interactor.output = controller

			return controller
		}

		try container.register(TimetableInteractor.self) {
			TimetableInteractor(updateTimetableUseCase: try $0.resolve(UpdateTimetableUseCase.self))
		}
	}
}
