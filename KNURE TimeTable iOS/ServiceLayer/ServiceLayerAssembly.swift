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
			CoreDataServiceImpl(persistentContainer: appConfig.persistentStoreContainer)
		}

		container.register(ImportService.self, name: "KNURE_Lesson") { _ in
			KNURELessonImportService(persistentContainer: appConfig.persistentStoreContainer)
		}

		container.register(ImportService.self, name: "KNURE_Group") { _ in
			KNUREGroupsImportService(persistentContainer: appConfig.persistentStoreContainer)
		}

		container.register(ImportService.self, name: "KNURE_Teacher") { _ in
			KNURETeachersImportService(persistentContainer: appConfig.persistentStoreContainer)
		}

		container.register(ImportService.self, name: "KNURE_Auditory") { _ in
			KNUREAuditoriesImportService(persistentContainer: appConfig.persistentStoreContainer)
		}
	}
}
