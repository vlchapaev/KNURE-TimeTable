//
//  AddItemsInteractor.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 01/01/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import Combine

protocol AddItemsInteractorInput {
	func obtainItems(type: Item.Kind) -> AnyPublisher<[AddItemsViewModel.Model], Error>
}

final class AddItemsInteractor: AddItemsInteractorInput {

	private let itemsUseCase: ItemsUseCase
	private let selectedItemsUseCase: SelectedItemsUseCase

	init(itemsUseCase: ItemsUseCase,
		 selectedItemsUseCase: SelectedItemsUseCase) {
		self.itemsUseCase = itemsUseCase
		self.selectedItemsUseCase = selectedItemsUseCase
	}

	// MARK: - AddItemsInteractorInput

	func obtainItems(type: Item.Kind) -> AnyPublisher<[AddItemsViewModel.Model], Error> {
		return selectedItemsUseCase.execute(())
			.combineLatest(itemsUseCase.execute(type))
			.map { result -> [AddItemsViewModel.Model] in
				let identifiers = result.0.map { $0.identifier }
				return result.1.map {
					AddItemsViewModel.Model(identifier: $0.identifier,
											text: $0.fullName ?? $0.shortName,
											selected: identifiers.contains($0.identifier))
				}
		}
		.eraseToAnyPublisher()
	}
}
