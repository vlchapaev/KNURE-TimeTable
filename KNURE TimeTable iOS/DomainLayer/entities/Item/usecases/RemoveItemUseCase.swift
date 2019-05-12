//
//  RemoveItemUseCase.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import PromiseKit

class RemoveItemUseCase: UseCase {

	typealias Query = NSNumber
	typealias Response = Void

	let itemRepository: ItemRepository

	init(itemRepository: ItemRepository) {
		self.itemRepository = itemRepository
	}

	func execute(_ query: NSNumber) -> Promise<Void> {
		return itemRepository.localRemoveItem(identifier: query)
	}
}
