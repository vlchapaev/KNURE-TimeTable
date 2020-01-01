//
//  TimetableCoordinator.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 26/10/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import UIKit

protocol TimetableCoordinatorOutput: AnyObject {

	func timetableCoordinatorDidFinish()
}

final class TimetableCoordinator: Coordinator {

	weak var output: TimetableCoordinatorOutput?

	// MARK: - Coordinator

	func start() {
	}
}
