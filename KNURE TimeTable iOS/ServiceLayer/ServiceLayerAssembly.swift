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

		container.register(CoreDataService.self) { _ in
			CoreDataService()
		}

		container.register(CoreDataSource.self) {
			PromisedCoreDataSource(coreDataService: $0.resolve(CoreDataService.self)!)
		}

		container.register(RemoteSource.self) { _ in
			PromisedRemoteSource()
		}
	}
}
