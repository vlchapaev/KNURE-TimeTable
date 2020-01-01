//
//  AddItemsInteractor.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 01/01/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

protocol AddItemsInteractorInput {
}

protocol AddItemsInteractorOutput: AnyObject {
}

final class AddItemsInteractor: AddItemsInteractorInput {

	weak var output: AddItemsInteractorOutput?

	private let saveItemUseCase: SaveItemUseCase
	private let removeItemUseCase: RemoveItemUseCase

	init(saveItemUseCase: SaveItemUseCase,
		 removeItemUseCase: RemoveItemUseCase) {
		self.saveItemUseCase = saveItemUseCase
		self.removeItemUseCase = removeItemUseCase
	}

	// MARK: - AddItemsInteractorInput

}
