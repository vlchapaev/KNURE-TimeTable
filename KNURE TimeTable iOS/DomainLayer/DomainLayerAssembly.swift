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
		container.register(SaveItemUseCase.self) { resolver in
			SaveItemUseCase(itemRepository: resolver.resolve(ItemRepository.self)!)
		}

		container.register(RemoveItemUseCase.self) { resolver in
			RemoveItemUseCase(itemRepository: resolver.resolve(ItemRepository.self)!)
		}

		container.register(ItemsUseCase.self) { resolver in
			ItemsUseCase(itemRepository: resolver.resolve(ItemRepository.self)!)
		}
	}

	func configureLesson(_ container: Container) {
		container.register(UpdateTimetableUseCase.self) { resolver in
			UpdateTimetableUseCase(lessonRepository: resolver.resolve(LessonRepository.self)!)
		}
	}
}
