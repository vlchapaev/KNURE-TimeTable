//
//  AddItemsAssembly.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 01/01/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

struct AddItemsAssembly: Assembly {

	func assemble(container: Container) {
		container.register(AddItemsViewController.self) {
			let interactor = try $0.resolve(AddItemsInteractor.self)
			let controller = AddItemsViewController()

			controller.interactor = interactor

			return controller
		}
		
		container.register(AddItemsInteractor.self) {
			AddItemsInteractor(
				itemsUseCase: try $0.resolve(ItemsUseCase.self),
				saveItemUseCase: try $0.resolve(SaveItemUseCase.self)
			)
		}
	}
}
