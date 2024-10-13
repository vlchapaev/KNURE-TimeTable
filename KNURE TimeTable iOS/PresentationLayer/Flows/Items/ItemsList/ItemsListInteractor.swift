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
}

final class ItemsListInteractor {

	private let addedItemsSubscription: any Subscribing<Void, [Item.Kind: [Item]]>

	init(addedItemsSubscription: any Subscribing<Void, [Item.Kind: [Item]]>) {
		self.addedItemsSubscription = addedItemsSubscription
	}
}

extension ItemsListInteractor: ItemsListInteractorInput {

	func observeAddedItems() -> AnyPublisher<[ItemsListView.Model], Never> {
		addedItemsSubscription.subscribe(())
			.map { dictionary in
				dictionary.map { key, value in
					ItemsListView.Model(
						sectionName: key.presentationValue,
						items: value.map {
							ItemCell.Model(title: $0.shortName, subtitle: String(describing: $0.updated))
						}
					)
				}
			}
			.eraseToAnyPublisher()
	}
}
