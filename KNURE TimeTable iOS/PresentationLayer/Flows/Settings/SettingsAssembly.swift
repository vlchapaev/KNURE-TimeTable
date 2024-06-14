//
//  SettingsAssembly.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 09.06.2024.
//  Copyright © 2024 Vladislav Chapaev. All rights reserved.
//

import SwiftUI

struct SettingsAssembly: Assembly {

	func assemble(container: Container) {
		container.register(SettingsView.self) { _ in
			SettingsView()
		}
	}
}
