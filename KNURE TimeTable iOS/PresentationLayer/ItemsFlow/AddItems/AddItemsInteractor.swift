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
}

final class AddItemsInteractor: AddItemsInteractorInput {

	private let itemsUseCase: ItemsUseCase

	init(itemsUseCase: ItemsUseCase) {
		self.itemsUseCase = itemsUseCase
	}

	// MARK: - AddItemsInteractorInput

	func obtain(items type: Item.Kind) -> AnyPublisher<[AddItemsViewModel.Section], Error> {
		return itemsUseCase.execute(type)
			.map { Dictionary(grouping: $0, by: \.hint) }
			.map { result -> [AddItemsViewModel.Section] in
				result.map { dict in
					let models = dict.value.map {
						AddItemsViewModel.Model(identifier: $0.identifier,
												text: $0.fullName ?? $0.shortName,
												selected: $0.selected)
					}
					return AddItemsViewModel.Section(title: dict.key, models: models)
				}
			}
			.eraseToAnyPublisher()
	}
}
