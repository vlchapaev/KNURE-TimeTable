//
//  ItemsCoordinator.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 01/01/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import UIKit

protocol ItemsCoordinatorOutput: AnyObject {

	func itemsCoordinatorDidFinish()
}

final class ItemsCoordinator: Coordinator {

	weak var output: ItemsCoordinatorOutput?

	// MARK: - Coordinator

	func start() {
	}
}
