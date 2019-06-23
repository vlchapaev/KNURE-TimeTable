//
//  DomainLayerAssembly.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import Foundation
import Swinject

class DomainLayerAssembly: Assembly {
	func configure(_ container: Container) {
		configureItem(container)
		configureLesson(container)
	}

	func configureItem(_ container: Container) {
		container.register(SaveItemUseCase.self) {
			SaveItemUseCase(itemRepository: $0.resolve(ItemRepository.self)!)
		}

		container.register(RemoveItemUseCase.self) {
			RemoveItemUseCase(itemRepository: $0.resolve(ItemRepository.self)!)
		}

		container.register(ItemsUseCase.self) {
			ItemsUseCase(itemRepository: $0.resolve(ItemRepository.self)!)
		}

		container.register(SelectedItemsObserver.self) {
			SelectedItemsObserver(itemRepository: $0.resolve(ItemRepository.self)!)
		}
	}

	func configureLesson(_ container: Container) {
		container.register(UpdateTimetableUseCase.self) {
			UpdateTimetableUseCase(lessonRepository: $0.resolve(LessonRepository.self)!)
		}
	}
}
