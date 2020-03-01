//
//  ViewControllerFactory.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 29/02/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import UIKit
import Swinject

protocol ViewControllerFactory {

	func make<T: UIViewController>(viewController type: T.Type) -> T
}

struct ViewControllerFactoryImpl: ViewControllerFactory {

	private let container: Container

	init(container: Container) {
		self.container = container
	}

	func make<T>(viewController type: T.Type) -> T where T: UIViewController {
		return container.resolve(type)!
	}
}
