//
//  ItemsAssembly.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 01/01/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

struct ItemsAssembly: Assembly {

	func assemble(container: Container) throws {
		try container.register(ItemsViewController.self) {
			let controller = ItemsViewController()
			controller.interactor = try $0.resolve(ItemsInteractor.self)
			return controller
		}

		try container.register(ItemsInteractor.self) {
			ItemsInteractor(removeItemUseCase: try $0.resolve(RemoveItemUseCase.self),
							selectedItemsUseCase: try $0.resolve(SelectedItemsUseCase.self))
		}
	}
}
