//
//  ItemsAssembly.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 01/01/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import Swinject

struct ItemsAssembly: Assembly {

	func assemble(container: Container) {
		container.register(ItemsViewController.self) {
			let controller = ItemsViewController()
			controller.interactor = $0.resolve(ItemsInteractor.self)
			return controller
		}

		container.register(ItemsInteractor.self) {
			ItemsInteractor(removeItemUseCase: $0.resolve(RemoveItemUseCase.self)!,
							selectedItemsUseCase: $0.resolve(SelectedItemsUseCase.self)!)
		}
	}
}
