//
//  ItemsListAssembly.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 11.06.2024.
//  Copyright © 2024 Vladislav Chapaev. All rights reserved.
//

import SwiftUI

struct ItemsListAssembly: Assembly {
	func assemble(container: Container) {
		container.register(ItemsListView.self) { container in
			ItemsListView { resolver in
				do {
					return try resolver(container)
				} catch {
					print(error)
					return EmptyView()
				}
			}
		}
	}
}
