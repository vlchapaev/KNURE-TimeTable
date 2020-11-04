//
//  RemoveItemUseCase.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

final class RemoveItemUseCase: UseCase<String, Void> {

	private let itemRepository: ItemRepository

	init(itemRepository: ItemRepository) {
		self.itemRepository = itemRepository
	}

//	 MARK: - UseCase

	override func execute(_ query: String) {
//		return itemRepository.localDeleteItem(identifier: query)
	}
}
