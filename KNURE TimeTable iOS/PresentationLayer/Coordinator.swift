//
//  Coordinator.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 26/10/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import UIKit

protocol Coordinator {

	var name: String { get }

	func start()
}

typealias CoordinatorOutput = TimetableCoordinatorOutput

final class MainCoordinator: Coordinator, CoordinatorOutput, MainViewControllerOutput {

	private var children: [Coordinator] = []

	private let window: UIWindow

	init(window: UIWindow) {
		self.window = window
	}

	// MARK: - Coordinator

	var name: String {
		return NSStringFromClass(MainCoordinator.self)
	}

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

	func startSettingsFlow() {
	}

	// MARK: - MainViewControllerOutput

	// MARK: - TimetableCoordinatorOutput

	func timetableCoordinatorDidFinish() {
		children.removeAll(where: { $0.name == NSStringFromClass(TimetableCoordinator.self) })
	}
}
