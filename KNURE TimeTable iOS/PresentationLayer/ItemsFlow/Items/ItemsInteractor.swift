//
//  ItemsInteractor.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 01/01/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import Combine

protocol ItemsInteractorInput {

	func observeSelectedItems() -> AnyPublisher<[ItemsViewModel.Section], Error>

	func remove(item identifier: String)

	func updateTimetable(item identifier: String)
}

final class ItemsInteractor {

	private let removeItemUseCase: RemoveItemUseCase
	private let selectedItemsUseCase: SelectedItemsUseCase
	private let updateTimetableUseCase: UpdateTimetableUseCase

	init(removeItemUseCase: RemoveItemUseCase,
		 selectedItemsUseCase: SelectedItemsUseCase,
		 updateTimetableUseCase: UpdateTimetableUseCase) {
		self.removeItemUseCase = removeItemUseCase
		self.selectedItemsUseCase = selectedItemsUseCase
		self.updateTimetableUseCase = updateTimetableUseCase
	}
}

extension ItemsInteractor: ItemsInteractorInput {

	func remove(item identifier: String) {
		removeItemUseCase.execute(identifier)
	}

	func observeSelectedItems() -> AnyPublisher<[ItemsViewModel.Section], Error> {
		return selectedItemsUseCase.execute(())
			.map { Dictionary(grouping: $0, by: \.type) }
			.map { result -> [ItemsViewModel.Section] in
				result.map { dictionary in
					let models = dictionary.value.map {
						ItemsViewModel.Model(identifier: $0.identifier,
											 text: $0.fullName ?? $0.shortName,
											 updated: $0.updated)
					}
					return ItemsViewModel.Section(name: dictionary.key.presentationValue, models: models)
				}
			}
			.eraseToAnyPublisher()
	}

	func updateTimetable(item identifier: String) {
		updateTimetableUseCase.execute(identifier)
	}
}
