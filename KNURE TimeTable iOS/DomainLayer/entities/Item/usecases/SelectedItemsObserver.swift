//
//  SelectedItemsObserver.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import RxSwift

class SelectedItemsObserver: UseCase {

	typealias Query = Void
	typealias Response = Observable<[Item]>

	let itemRepository: ItemRepository

	init(itemRepository: ItemRepository) {
		self.itemRepository = itemRepository
	}

	func execute(_ query: Void) -> Observable<[Item]> {
		return self.itemRepository.localSelectedItems()
	}
}
