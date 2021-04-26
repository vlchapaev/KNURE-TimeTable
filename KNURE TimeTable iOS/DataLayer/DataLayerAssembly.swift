//
//  DataLayerAssembly.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

struct DataLayerAssembly: Assembly {

	func assemble(container: Container) throws {
		try container.register(ItemRepository.self, named: "KNURE", in: .graph) {
			KNUREItemRepository(coreDataService: try $0.resolve(),
								networkService: try $0.resolve())
		}

		try container.register(LessonRepository.self, named: "KNURE", in: .graph) {
			KNURELessonRepository(coreDataService: try $0.resolve(),
								  importService: try $0.resolve(ImportService.self, named: "KNURE_Lesson"))
		}
	}
}
