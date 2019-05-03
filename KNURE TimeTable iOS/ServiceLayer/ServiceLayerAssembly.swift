//
//  ServiceLayerAssembly.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 03/05/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import Swinject

class ServiceLayerAssembly: Assembly {
	func configure(_ container: Container) {

		container.register(CoreDataService.self) { resolver in
			CoreDataService()
		}

		container.register(CoreDataSource.self) { resolver in
			PromisedCoreDataSource(coreDataService: resolver.resolve(CoreDataService.self)!)
		}

		container.register(RemoteSource.self) { resolver in
			// TODO: session configuration
			PromisedRemoteSource(configuration: URLSessionConfiguration())
		}
	}
}
