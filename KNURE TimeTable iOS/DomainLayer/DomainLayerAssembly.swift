//
//  DomainLayerAssembly.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

struct DomainLayerAssembly: Assembly {
	func assemble(container: Container) {
		configureItem(container)
		configureLesson(container)
	}

	func configureItem(_ container: Container) {
		container.register(SaveItemUseCase.self) {
			SaveItemUseCase(repository: try $0.resolve(named: "KNURE"))
		}

		container.register(RemoveItemUseCase.self) {
			RemoveItemUseCase(repository: try $0.resolve(named: "KNURE"))
		}

		container.register(SelectedItemsUseCase.self) {
			SelectedItemsUseCase(repository: try $0.resolve(named: "KNURE"))
		}

		container.register(ItemsUseCase.self) {
			ItemsUseCase(repository: try $0.resolve(named: "KNURE"))
		}
	}

	func configureLesson(_ container: Container) {
		container.register(UpdateTimetableUseCase.self) {
			UpdateTimetableUseCase(repository: try $0.resolve(named: "KNURE"))
		}
	}
}
