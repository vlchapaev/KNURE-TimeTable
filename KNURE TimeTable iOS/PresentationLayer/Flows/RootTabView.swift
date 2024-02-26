//
//  RootTabView.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 08.06.2024.
//  Copyright © 2024 Vladislav Chapaev. All rights reserved.
//

import SwiftUI

struct RootTabView: View {

	let resolver: DIResolvingView

	var body: some View {
		TabView {
			AnyView(
				resolver { try $0.resolve(TimetableView.self) }
					.tabItem { Label("Timetable", systemImage: "calendar") }
			)
			AnyView(
				resolver { try $0.resolve(ItemsListView.self) }
			)
			AnyView(
				resolver { try $0.resolve(SettingsView.self) }
			)
		}
	}
}
