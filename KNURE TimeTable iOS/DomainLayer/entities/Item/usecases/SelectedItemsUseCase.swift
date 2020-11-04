//
//  SelectedItemsUseCase.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

final class SelectedItemsUseCase: UseCase<Void, [Item]> {

	private let itemRepository: ItemRepository

	init(itemRepository: ItemRepository) {
		self.itemRepository = itemRepository
	}

	// MARK: - UseCase

	override func execute(_ query: Void) -> [Item] {
		return []
//		return itemRepository.localSelectedItems()
	}
}
