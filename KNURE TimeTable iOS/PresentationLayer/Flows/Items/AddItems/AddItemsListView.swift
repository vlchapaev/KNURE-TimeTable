//
//  AddItemsListView.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 27.02.2024.
//  Copyright © 2024 Vladislav Chapaev. All rights reserved.
//

import SwiftUI

struct AddItemsListViewModel: Identifiable {

	let id = UUID()
	let title: String
	let selected: Bool
}

struct AddItemsListView: View {

	@State private var searchText = ""
	var viewModel: [AddItemsListViewModel] = []

    var body: some View {
		NavigationStack {
			List(viewModel) { record in
				AddItemView(model: .init(title: record.title, selected: record.selected))
			}
			.navigationTitle("Add Items List")
			.listStyle(.plain)
		}
		.searchable(text: $searchText)
    }
}

#Preview {
	AddItemsListView(viewModel: [
		.init(title: "some", selected: false),
		.init(title: "some 1", selected: true),
		.init(title: "some 2", selected: false)
	])
}
