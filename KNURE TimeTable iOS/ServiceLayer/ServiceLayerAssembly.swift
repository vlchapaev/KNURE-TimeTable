//
//  ServiceLayerAssembly.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 03/05/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import Swinject
import CoreData

struct ServiceLayerAssembly: Assembly {

	func assemble(container: Container) {

		let appConfig = container.resolve(ApplicationConfig.self)!

		container.register(CoreDataService.self) { _ in
			CoreDataServiceImpl(persistentContainer: appConfig.persistentStoreContainer)
		}

		container.register(ReactiveCoreDataService.self) { _ in
			ReactiveCoreDataServiceImpl(persistentContainer: appConfig.persistentStoreContainer)
		}

		container.register(ReactiveNetworkService.self) { _ in
			ReactiveNetworkServiceImpl(configuration: appConfig.urlSessionConfiguration)
		}

		container.register(ImportService.self, name: "KNURELesson") { _ in
			KNURELessonImportService(persistentContainer: appConfig.persistentStoreContainer)
		}

		container.register(ImportService.self, name: "KNUREItem") { _ in
			KNUREItemImportService(persistentContainer: appConfig.persistentStoreContainer)
		}
	}
}
