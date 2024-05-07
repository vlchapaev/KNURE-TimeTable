//
//  ServiceLayerAssembly.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 03/05/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import CoreData

struct ServiceLayerAssembly: Assembly {

	func assemble(container: Container) {

		container.register(CoreDataService.self, in: .graph) { container in
			let appConfig = try container.resolve(Configuration.self)
			return CoreDataServiceImpl(persistentContainer: appConfig.persistentStoreContainer)
		}

		container.register(ImportService.self, named: "KNURE_Lesson", in: .graph) { container in
			let appConfig = try container.resolve(Configuration.self)
			return KNURELessonImportService(persistentContainer: appConfig.persistentStoreContainer)
		}

		container.register(NetworkService.self, in: .graph) { container in
			let appConfig = try container.resolve(Configuration.self)
			return NetworkService(configuration: appConfig.urlSessionConfiguration)
		}
	}
}
