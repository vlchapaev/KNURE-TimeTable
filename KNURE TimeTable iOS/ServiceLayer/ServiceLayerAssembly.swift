//
//  ServiceLayerAssembly.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 03/05/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import Swinject

struct ServiceLayerAssembly: Assembly {

	func assemble(container: Container) {

		let appConfig = container.resolve(ApplicationConfig.self)!

		container.register(ReactiveCoreDataService.self) { _ in
			ReactiveCoreDataServiceImpl(persistentContainer: appConfig.persistentStoreContainer)
		}

		container.register(ReactiveNetworkService.self) { _ in
			ReactiveNetworkServiceImpl(configuration: appConfig.urlSessionConfiguration)
		}

		container.register(ImportService.self, name: "KNURE") { _ in
			KNURELessonImportSevice(persistentContainer: appConfig.persistentStoreContainer)
		}

		container.register(ImportService.self, name: "KNURE") { _ in
			KNUREItemImportService(persistentContainer: appConfig.persistentStoreContainer)
		}
	}
}
