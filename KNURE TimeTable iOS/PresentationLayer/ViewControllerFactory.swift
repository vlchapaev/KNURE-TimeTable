//
//  ViewControllerFactory.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 29/02/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import UIKit

protocol ViewControllerFactory {

	func make<T: UIViewController>(viewController type: T.Type, in container: Container) throws -> T
}

struct ViewControllerFactoryImpl: ViewControllerFactory {

	func make<T>(viewController type: T.Type, in container: Container) throws -> T where T: UIViewController {
		return try container.resolve(type)
	}
}
