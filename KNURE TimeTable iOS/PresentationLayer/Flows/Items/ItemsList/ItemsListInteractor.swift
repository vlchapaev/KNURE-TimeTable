//
//  ItemsListInteractor.swift
//  KNURE TimeTable
//
//  Created by Vladislav Chapaev on 01.10.2024.
//  Copyright © 2024 Vladislav Chapaev. All rights reserved.
//

import Combine

protocol ItemsListInteractorInput {

	func observeAddedItems() -> AnyPublisher<[ItemsListView.Model], Never>

	func updateTimetable(of type: Item.Kind, identifier: String) async throws
}

final class ItemsListInteractor {

	private let addedItemsSubscription: any Subscribing<Void, [Item.Kind: [Item]]>
	private let updateTimetableUseCase: any UseCase<UpdateTimetableUseCase.Query, Void>

	init(
		addedItemsSubscription: any Subscribing<Void, [Item.Kind: [Item]]>,
		updateTimetableUseCase: any UseCase<UpdateTimetableUseCase.Query, Void>
	) {
		self.addedItemsSubscription = addedItemsSubscription
		self.updateTimetableUseCase = updateTimetableUseCase
	}
}

extension ItemsListInteractor: ItemsListInteractorInput {

	func observeAddedItems() -> AnyPublisher<[ItemsListView.Model], Never> {
		addedItemsSubscription.subscribe(())
			.map { dictionary in
				dictionary.map { key, value in
					ItemsListView.Model(
						id: value.map(\.identifier).joined(),
						sectionName: key.presentationValue,
						items: value.map {
							ItemCell.Model(title: $0.shortName, subtitle: String(describing: $0.updated))
						}
					)
				}
			}
			.eraseToAnyPublisher()
	}

	func updateTimetable(of type: Item.Kind, identifier: String) async throws {
		try await updateTimetableUseCase.execute(.init(identifier: identifier, type: type))
	}
}
