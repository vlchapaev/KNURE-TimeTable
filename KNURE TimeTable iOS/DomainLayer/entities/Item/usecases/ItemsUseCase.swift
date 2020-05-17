//
//  ItemsUseCase.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 07/01/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import RxSwift

final class ItemsUseCase: UseCase<Item.Kind, Observable<[Item]>> {

	private let itemRepository: ItemRepository

	init(itemRepository: ItemRepository) {
		self.itemRepository = itemRepository
	}

	// MARK: - UseCase

	override func execute(_ query: Item.Kind) -> Observable<[Item]> {
		return itemRepository.remoteItems(type: query)
	}
}
