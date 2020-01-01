//
//  Coordinator.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 26/10/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import UIKit

final class MainCoordinator: Coordinator {

	private var children: [Coordinator] = []

	private let window: UIWindow

	init(window: UIWindow) {
		self.window = window
	}

	// MARK: - Coordinator

	func start() {
		let controller = MainViewController(output: self)
		window.rootViewController = controller
		window.makeKeyAndVisible()
	}

	func startTimeTableFlow() {
		let coordinator = TimetableCoordinator()
		coordinator.output = self
		coordinator.start()
		children.append(coordinator)
	}

	func startItemsFlow() {
		let coordinator = ItemsCoordinator()
		coordinator.output = self
		coordinator.start()
		children.append(coordinator)
	}

	func startSettingsFlow() {
	}
}

extension MainCoordinator: MainViewControllerOutput {
}

extension MainCoordinator: TimetableCoordinatorOutput {
	func timetableCoordinatorDidFinish() {
		children.removeAll(where: { $0.classType == TimetableCoordinator.self })
	}
}

extension MainCoordinator: ItemsCoordinatorOutput {
	func itemsCoordinatorDidFinish() {
		children.removeAll(where: { $0.classType == ItemsCoordinator.self })
	}
}
