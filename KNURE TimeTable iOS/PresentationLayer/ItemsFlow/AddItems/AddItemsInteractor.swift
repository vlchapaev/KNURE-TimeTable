//
//  AddItemsInteractor.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 01/01/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import RxSwift

protocol AddItemsInteractorInput {
	func obtainItems() -> Observable<[Item]>
}

protocol AddItemsInteractorOutput: AnyObject {
}

final class AddItemsInteractor: AddItemsInteractorInput {

	weak var output: AddItemsInteractorOutput?

	private let itemsUseCase: ItemsUseCase

	init(itemsUseCase: ItemsUseCase) {
		self.itemsUseCase = itemsUseCase
	}

	// MARK: - AddItemsInteractorInput

	func obtainItems() -> Observable<[Item]> {
		return itemsUseCase.execute(())
	}
}
