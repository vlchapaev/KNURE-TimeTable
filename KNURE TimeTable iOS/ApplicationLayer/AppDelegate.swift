//
//  AppDelegate.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import UIKit
import XCoordinator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
	var coordinator: MainCoordinator?

	private var container: Container!
	private let factories: [Assembly] = [
		ApplicationLayerAssembly(),
		ServiceLayerAssembly(),
		DataLayerAssembly(),
		DomainLayerAssembly(),
		PresentationLayerAssembly()
	]

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		container = .shared
		do {
			try factories.forEach { try $0.assemble(container: container!) }
		} catch {
			print(error)
		}

		window = UIWindow()
//		let factory = container.resolve(ViewControllerFactory.self)!
//		coordinator = MainCoordinator(viewControllerFactory: factory)
//		coordinator?.strongRouter.setRoot(for: window!)
		return true
	}
}
