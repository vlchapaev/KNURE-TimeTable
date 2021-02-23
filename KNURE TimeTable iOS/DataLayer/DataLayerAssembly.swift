//
//  DataLayerAssembly.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import Swinject

struct DataLayerAssembly: Assembly {

	func assemble(container: Container) {
		container.register(ItemRepository.self) {
			KNUREItemRepository(coreDataService: $0.resolve(CoreDataService.self)!)
		}

		container.register(LessonRepository.self) {
			KNURELessonRepository(coreDataService: $0.resolve(CoreDataService.self)!,
								  importService: $0.resolve(ImportService.self, name: "KNURE_Lesson")!)
		}
	}
}
