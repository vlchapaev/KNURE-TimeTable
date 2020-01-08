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

	private let removeItemUseCase: RemoveItemUseCase

	init(removeItemUseCase: RemoveItemUseCase) {
		self.removeItemUseCase = removeItemUseCase
	}

	// MARK: - ItemsInteractorInput

}
