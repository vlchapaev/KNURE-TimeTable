//
//  ItemsAssembly.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 01/01/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import Swinject

struct ItemsAssembly: Assembly {

	func configure(_ container: Container) {
		container.register(ItemsViewController.self) {
			let interactor = $0.resolve(ItemsInteractor.self)!
			let controller = ItemsViewController()

			controller.interactor = interactor
			interactor.output = controller

			return controller
		}

		container.register(ItemsInteractor.self) {
			ItemsInteractor(saveItemUseCase: $0.resolve(SaveItemUseCase.self)!,
							removeItemUseCase: $0.resolve(RemoveItemUseCase.self)!)
		}
	}
}
