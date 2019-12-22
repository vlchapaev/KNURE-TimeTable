//
//  TimetableAssembly.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 22/12/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import Swinject

struct TimetableAssembly: Assembly {

	func configure(_ container: Container) {
		container.register(TimetableViewController.self) {
			let interactor = $0.resolve(TimetableInteractor.self)!
			let controller = TimetableViewController()

			controller.interactor = interactor
			interactor.output = controller

			return controller
		}

		container.register(TimetableInteractor.self) {
			TimetableInteractor(updateTimetableUseCase: $0.resolve(UpdateTimetableUseCase.self)!)
		}
	}
}
