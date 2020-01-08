//
//  AppDelegate.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import UIKit
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
	private var coordinator: Coordinator?

	private let container: Container = Container(defaultObjectScope: .transient) { container in
		let factories: [Assembly] = [
			ApplicationLayerAssembly(),
			ServiceLayerAssembly(),
			DataLayerAssembly(),
			DomainLayerAssembly(),
			PresentationLayerAssembly()
		]

		factories.forEach { $0.assemble(container: container) }
	}

    func application(_: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerWindow()
        return true
    }

    func registerWindow() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
		coordinator = MainCoordinator(window: window)
		coordinator?.start()
    }

}
