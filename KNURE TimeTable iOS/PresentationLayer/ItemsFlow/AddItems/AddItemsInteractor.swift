//
//  AddItemsInteractor.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 01/01/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import Combine

protocol AddItemsInteractorInput {

	func obtain(items type: Item.Kind) -> AnyPublisher<[AddItemsViewModel.Section], Error>

	func save(item: AddItemsViewModel.Model, type: Item.Kind)
}

final class AddItemsInteractor {

	private let itemsUseCase: ItemsUseCase
	private let saveItemUseCase: SaveItemUseCase

	init(itemsUseCase: ItemsUseCase,
		 saveItemUseCase: SaveItemUseCase) {
		self.itemsUseCase = itemsUseCase
		self.saveItemUseCase = saveItemUseCase
	}
}

extension AddItemsInteractor: AddItemsInteractorInput {

	func obtain(items type: Item.Kind) -> AnyPublisher<[AddItemsViewModel.Section], Error> {
		return itemsUseCase.execute(type)
			.map { Dictionary(grouping: $0, by: \.hint) }
			.map { result -> [AddItemsViewModel.Section] in
				result.map { dictionary in
					let models = dictionary.value.map {
						AddItemsViewModel.Model(identifier: $0.identifier,
												text: $0.fullName ?? $0.shortName,
												selected: $0.selected)
					}
					return AddItemsViewModel.Section(title: dictionary.key, models: models)
				}
			}
			.eraseToAnyPublisher()
	}

	func save(item: AddItemsViewModel.Model, type: Item.Kind) {
		saveItemUseCase.execute(.init(identifier: item.identifier,
									  shortName: item.text,
									  type: type,
									  selected: true))
	}
}
