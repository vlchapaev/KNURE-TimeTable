//
//  RemoveItemUseCase.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import PromiseKit

class RemoveItemUseCase: UseCase {

	typealias Query = String
	typealias Response = Promise<Void>

	let itemRepository: ItemRepository

	init(itemRepository: ItemRepository) {
		self.itemRepository = itemRepository
	}

	func execute(_ query: String) -> Promise<Void> {
		return itemRepository.localDeleteItem(identifier: query)
	}
}
