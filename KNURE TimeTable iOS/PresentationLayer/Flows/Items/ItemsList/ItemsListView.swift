//
//  ItemsListView.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 26.02.2024.
//  Copyright © 2024 Vladislav Chapaev. All rights reserved.
//

import SwiftUI

struct ItemsListView: View {

	@State var viewModel: [ItemsListView.Model] = []

	private let interactor: ItemsListInteractor

	init(
		interactor: ItemsListInteractor
	) {
		self.interactor = interactor
	}

    var body: some View {
		NavigationStack {
			List(viewModel) { record in
				Section(record.sectionName) {
					ForEach(record.items) { item in
						ItemCell(model: item)
					}
				}
			}
			.onReceive(interactor.observeAddedItems()) { output in
				viewModel = output
			}
			.navigationTitle("Items List")
			.toolbar {
				ToolbarItem(placement: .primaryAction) {
					NavigationLink {
						AddItemsListView(
							interactor: AddItemsInteractor(
								itemsUseCase: ItemsUseCase(
									repository: KNUREItemRepository(
										coreDataService: CoreDataServiceImpl(
											persistentContainer: DefaultAppConfig().persistentStoreContainer
										),
										networkService: NetworkServiceImpl(
											configuration: DefaultAppConfig().urlSessionConfiguration
										)
									)
								),
								saveItemUseCase: SaveItemUseCase(
									repository: KNUREItemRepository(
										coreDataService: CoreDataServiceImpl(
											persistentContainer: DefaultAppConfig().persistentStoreContainer
										),
										networkService: NetworkServiceImpl(
											configuration: DefaultAppConfig().urlSessionConfiguration
										)
									)
								)
							)
						)
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
