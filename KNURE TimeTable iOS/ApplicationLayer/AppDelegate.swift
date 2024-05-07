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

	private var container: Container = .shared
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

		do {
			factories.forEach { $0.assemble(container: container) }

			let factory = try container.resolve(ViewControllerFactory.self)
			let itemsController = try factory.make(viewController: ItemsViewController.self, in: container)
			itemsController.output = self
			let navController = UINavigationController(rootViewController: itemsController)
			window?.rootViewController = navController
			window?.makeKeyAndVisible()
		} catch {
			print(error)
		}

		let docDirPath =
		NSSearchPathForDirectoriesInDomains(.documentDirectory,
											.userDomainMask, true).first
		print(docDirPath)

		return true
	}
}

extension AppDelegate: ItemsViewControllerOutput {
	func controller(_ controller: ItemsViewController, addItems type: Item.Kind) {
		do {
			let newController = try container.resolve(AddItemsViewController.self)
			newController.configure(type: type)
			(window?.rootViewController as? UINavigationController)?
				.pushViewController(newController, animated: true)
		} catch {
			print(error)
		}
	}
}
