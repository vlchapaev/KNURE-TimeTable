//
//  MainCoordinator.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 26/10/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import UIKit
//import XCoordinator
//
//enum MainRoute: Route {
//	case timetable
//	case items
//	case settings
//}
//
//final class MainCoordinator: TabBarCoordinator<MainRoute> {
//
//	private let itemsRouter: StrongRouter<ItemsRouter>
//
//	init(viewControllerFactory: ViewControllerFactory) {
//        let itemsCoordinator = ItemsCoordinator(viewControllerFactory: viewControllerFactory)
//        itemsCoordinator.rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 2)
//
//		self.itemsRouter = itemsCoordinator.strongRouter
//
//		super.init(tabs: [itemsRouter], select: itemsRouter)
//    }
//
//	override func prepareTransition(for route: MainRoute) -> TabBarTransition {
//		switch route {
//		case .timetable, .items, .settings:
//			return .select(itemsRouter)
//		}
//	}
//}
