//
//  DomainLayerAssembly.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

struct DomainLayerAssembly: Assembly {
	func assemble(container: Container) throws {
		try configureItem(container)
		try configureLesson(container)
	}

	func configureItem(_ container: Container) throws {
		try container.register(SaveItemUseCase.self) {
			SaveItemUseCase(itemRepository: try $0.resolve(named: "KNURE"))
		}

		try container.register(RemoveItemUseCase.self) {
			RemoveItemUseCase(itemRepository: try $0.resolve(named: "KNURE"))
		}

		try container.register(SelectedItemsUseCase.self) {
			SelectedItemsUseCase(itemRepository: try $0.resolve(named: "KNURE"))
		}

		try container.register(ItemsUseCase.self) {
			ItemsUseCase(itemRepository: try $0.resolve(named: "KNURE"))
		}
	}

	func configureLesson(_ container: Container) throws {
		try container.register(UpdateTimetableUseCase.self) {
			UpdateTimetableUseCase(lessonRepository: try $0.resolve(named: "KNURE"))
		}
	}
}
