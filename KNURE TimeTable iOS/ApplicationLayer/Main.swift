//
//  Main.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import SwiftUI

@main
struct Main: App {

	private var container: Container = .shared
	private let factories: [Assembly] = [
		ApplicationLayerAssembly(),
		ServiceLayerAssembly(),
		DataLayerAssembly(),
		DomainLayerAssembly(),
		PresentationLayerAssembly()
	]

	init() {
		factories.forEach { $0.assemble(container: container) }
	}

	var body: some Scene {
		WindowGroup {
			RootTabView { resolver in
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
