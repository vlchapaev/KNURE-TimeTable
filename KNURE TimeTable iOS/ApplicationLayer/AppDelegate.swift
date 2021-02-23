//
//  AppDelegate.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import UIKit
import Swinject
import XCoordinator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
	var coordinator: MainCoordinator?

	private let container: Swinject.Container = Container(defaultObjectScope: .transient) { container in
		let factories: [Assembly] = [
			ApplicationLayerAssembly(),
			ServiceLayerAssembly(),
			DataLayerAssembly(),
			DomainLayerAssembly(),
			PresentationLayerAssembly()
		]

		factories.forEach { $0.assemble(container: container) }
	}

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow()
//		let factory = container.resolve(ViewControllerFactory.self)!
//		coordinator = MainCoordinator(viewControllerFactory: factory)
//		coordinator?.strongRouter.setRoot(for: window!)
		return true
	}
}
