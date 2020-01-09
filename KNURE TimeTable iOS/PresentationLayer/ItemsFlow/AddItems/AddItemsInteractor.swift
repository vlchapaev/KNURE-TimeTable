//
//  AddItemsInteractor.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 01/01/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import RxSwift

protocol AddItemsInteractorInput {
	func obtainItems(type: TimetableItem) -> Observable<[AddItemsViewModel.Model]>
}

protocol AddItemsInteractorOutput: AnyObject {
}

final class AddItemsInteractor: AddItemsInteractorInput {

	weak var output: AddItemsInteractorOutput?

	private let itemsUseCase: ItemsUseCase
	private let selectedItemsUseCase: SelectedItemsUseCase

	init(itemsUseCase: ItemsUseCase,
		 selectedItemsUseCase: SelectedItemsUseCase) {
		self.itemsUseCase = itemsUseCase
		self.selectedItemsUseCase = selectedItemsUseCase
	}

	// MARK: - AddItemsInteractorInput

	func obtainItems(type: TimetableItem) -> Observable<[AddItemsViewModel.Model]> {
		return Observable.zip(itemsUseCase.execute(type), selectedItemsUseCase.execute(()))
			.map {
				let identifiers = $0.1.map { $0.identifier }
				return $0.0.map {
					AddItemsViewModel.Model(identifier: $0.identifier,
											text: $0.shortName,
											selected: identifiers.contains($0.identifier))
				}
		}
	}
}
