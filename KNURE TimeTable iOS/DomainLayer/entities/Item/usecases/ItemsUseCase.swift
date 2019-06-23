//
//  ItemsUseCase.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 12/05/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import PromiseKit

class ItemsUseCase: UseCase {

	typealias Query = TimetableItem
	typealias Response = Promise<[Item]>

	let itemRepository: ItemRepository

	init(itemRepository: ItemRepository) {
		self.itemRepository = itemRepository
	}

	func execute(_ query: TimetableItem) -> Promise<[Item]> {
		return itemRepository.remoteItems(ofType: query)
			.then { response -> Promise<[Item]> in
				return Promise.value([])
		}
	}
}
