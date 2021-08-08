//
//  AppDelegate.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

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
		window = UIWindow()
		container = .shared

		do {
			try factories.forEach { try $0.assemble(container: container) }

			let factory = try container.resolve(ViewControllerFactory.self)
			let itemsController = try factory.make(viewController: AddItemsViewController.self)
			let navController = UINavigationController(rootViewController: itemsController)
			window?.rootViewController = navController
			window?.makeKeyAndVisible()
		} catch {
			print(error)
		}

		return true
	}
}
