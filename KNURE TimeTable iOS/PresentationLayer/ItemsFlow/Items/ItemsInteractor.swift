//
//  ItemsInteractor.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 01/01/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

protocol ItemsInteractorInput {
}

protocol ItemsInteractorOutput: AnyObject {
}

final class ItemsInteractor: ItemsInteractorInput {

	weak var output: ItemsInteractorOutput?

	private let saveItemUseCase: SaveItemUseCase
	private let removeItemUseCase: RemoveItemUseCase

	init(saveItemUseCase: SaveItemUseCase,
		 removeItemUseCase: RemoveItemUseCase) {
		self.saveItemUseCase = saveItemUseCase
		self.removeItemUseCase = removeItemUseCase
	}

	// MARK: - ItemsInteractorInput

}
