//
//  ItemsCoordinator.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 01/01/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import UIKit
//import XCoordinator
//
//enum ItemsRouter: Route {
//	case itemsList
//	case addItems(Item.Kind)
//	case close
//}
//
//final class ItemsCoordinator: NavigationCoordinator<ItemsRouter> {
//
//	private let viewControllerFactory: ViewControllerFactory
//
//	init(viewControllerFactory: ViewControllerFactory) {
//		self.viewControllerFactory = viewControllerFactory
//		super.init(initialRoute: .itemsList)
//	}
//
//	override func prepareTransition(for route: ItemsRouter) -> NavigationTransition {
//		switch route {
//		case .close:
//			return .popToRoot()
//
//		case .addItems(let type):
//			// swiftlint:disable:next force_try
//			let controller = try! viewControllerFactory.make(viewController: AddItemsViewController.self)
//			controller.output = self
//			controller.configure(type: type)
//			return .push(controller)
//
//		case .itemsList:
//			// swiftlint:disable:next force_try
//			let controller = try! viewControllerFactory.make(viewController: ItemsViewController.self)
//			controller.output = self
//			return .push(controller)
//		}
//	}
//}
//
//extension ItemsCoordinator: ItemsViewControllerOutput {
//
//	func controller(_ controller: ItemsViewController, addItems type: Item.Kind) {
//		unownedRouter.trigger(.addItems(type))
//	}
//}
//
//extension ItemsCoordinator: AddItemsViewControllerOutput {
//
//	func didFinish(_ controller: AddItemsViewController) {
//		unownedRouter.trigger(.itemsList)
//	}
//}
