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

		let appConfig = container.resolve(ApplicationConfig.self)!

		container.register(PromisedCoreDataService.self) { _ in
			PromisedCoreDataServiceImpl(persistentContainer: appConfig.persistentStoreContainer)
		}

		container.register(ReactiveCoreDataService.self) { _ in
			ReactiveCoreDataServiceImpl(persistentContainer: appConfig.persistentStoreContainer)
		}

		container.register(PromisedNetworkService.self) { _ in
			PromisedNetworkServiceImpl(configuration: appConfig.urlSessionConfiguration)
		}

		container.register(ImportService.self, name: "KNURELesson") { _ in
			KNURELessonImportSevice(persistentContainer: appConfig.persistentStoreContainer)
		}

		container.register(ImportService.self, name: "KNUREItem") { _ in
			KNURELessonImportSevice(persistentContainer: appConfig.persistentStoreContainer)
		}
	}
}
