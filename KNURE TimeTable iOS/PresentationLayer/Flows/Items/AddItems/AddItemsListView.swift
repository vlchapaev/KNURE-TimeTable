//
//  AddItemsListView.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 27.02.2024.
//  Copyright © 2024 Vladislav Chapaev. All rights reserved.
//

import SwiftUI

struct AddItemsListView: View {

	@Environment(\.dismiss) private var dismiss
	@State private var searchText = ""
	@State private var selected: Int? {
		didSet {
			if let selected {
				Task {
					try await interactor.save(item: viewModel[selected].item)
				}
			}
			dismiss()
		}
	}

	@State private var viewModel: [AddItemsListView.Model] = []
	@State private var isErrorOccured: Bool = false

	let interactor: AddItemsInteractor

    var body: some View {
		NavigationStack {
			List(viewModel, selection: $selected) { record in
				AddItemCell(model: .init(title: record.title, selected: record.selected))
			}
			.navigationTitle("Add Items List")
			.listStyle(.plain)
			.task {
				do {
					viewModel = try await interactor.obtainItems(kind: .group)
				} catch {
					isErrorOccured = true
				}
			}
			.searchable(text: $searchText)
			.alert("An Error has occured", isPresented: $isErrorOccured) {
				Button(role: .cancel) {
					isErrorOccured = false
				} label: {
					Text("Ok")
				}
			}
		}
    }
}

extension AddItemsListView {

	struct Model: Identifiable, Sendable {
		var id: String { item.identifier }
		let title: String
		let selected: Bool

		let item: Item
	}
}
