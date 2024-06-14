//
//  AddItemsAssembly.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 11.06.2024.
//  Copyright © 2024 Vladislav Chapaev. All rights reserved.
//

struct AddItemsAssembly: Assembly {
	func assemble(container: Container) {
		container.register(AddItemsListView.self) { _ in
			AddItemsListView()
		}
	}
}
