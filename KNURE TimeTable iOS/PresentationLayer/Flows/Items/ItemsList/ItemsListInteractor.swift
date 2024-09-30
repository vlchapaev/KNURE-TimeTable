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
			.map {
				ItemsListView.Model(sectionName: <#T##String#>, items: <#T##[ItemCell.Model]#>)
			}
			.eraseToAnyPublisher()
	}
}
