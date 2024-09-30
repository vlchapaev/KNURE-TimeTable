//
//  ItemsListView.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 26.02.2024.
//  Copyright © 2024 Vladislav Chapaev. All rights reserved.
//

import SwiftUI

struct ItemsListView: View {

	var viewModel: [ItemsListView.Model] = []

	let resolver: DIResolvingView

    var body: some View {
		NavigationStack {
			List(viewModel) { record in
				Section(record.sectionName) {
					ForEach(record.items) { item in
						ItemCell(model: item)
					}
				}
			}
			.navigationTitle("Items List")
			.toolbar {
				ToolbarItem(placement: .primaryAction) {
					NavigationLink {
						AnyView(resolver { try $0.resolve(AddItemsListView.self) })
					} label: {
						Image(systemName: "plus")
					}
				}
			}
		}
		.tabItem {
			Label("Items", systemImage: "list.bullet")
		}
    }
}

extension ItemsListView {
	struct Model: Identifiable {

		let id = UUID()
		let sectionName: String
		var items: [ItemCell.Model] = []
	}
}

#Preview {

	ItemsListView(viewModel: [
		.init(sectionName: "Groups", items: [
			.init(title: "group 1", subtitle: "updated 23.10.1111", updating: false)
		]),
		.init(sectionName: "Teachers", items: [
			.init(title: "Very very long teacher name from some country", subtitle: "updated 23.10.1111", updating: true),
			.init(title: "teacher 2", subtitle: "updated 23.10.1111", updating: false)
		]),
		.init(sectionName: "Auditories", items: [
			.init(title: "auditory 1", subtitle: "updated 23.10.1111", updating: false)
		])
	], resolver: { _ in EmptyView() })
}
