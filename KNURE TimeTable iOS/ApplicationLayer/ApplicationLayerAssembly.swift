//
//  ApplicationLayerAssembly.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import Swinject

struct ApplicationLayerAssembly: Assembly {

	func assemble(container: Container) {
		registerApplicationConfig(container)
	}

	func registerApplicationConfig(_ container: Container) {
		container.register(Configuration.self) { _ in
			DefaultAppConfig()
		}
	}
}
