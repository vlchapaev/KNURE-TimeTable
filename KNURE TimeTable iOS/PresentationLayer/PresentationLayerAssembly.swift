//
//  PresentationLayerAssembly.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

struct PresentationLayerAssembly: Assembly {

	func assemble(container: Container) throws {
		let assembies: [Assembly] = [
			TimetableAssembly(),

			ItemsAssembly(),
			AddItemsAssembly()
		]

		try assembies.forEach { try $0.assemble(container: container) }

		try configureFactories(container)
	}

	private func configureFactories(_ container: Container) throws {
		container.register(ViewControllerFactory.self, in: .graph) {
			ViewControllerFactoryImpl(container: $0)
		}
	}
}
