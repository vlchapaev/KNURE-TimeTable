//
//  PresentationLayerAssembly.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import SwiftUI

typealias DIResolvingView = ((Container) throws -> any View) -> any View

struct PresentationLayerAssembly: Assembly {

	func assemble(container: Container) {
		let assembies: [Assembly] = [
			TimetableAssembly(),

			ItemsListAssembly(),
			AddItemsAssembly(),

			SettingsAssembly()
		]

		assembies.forEach { $0.assemble(container: container) }
	}
}
