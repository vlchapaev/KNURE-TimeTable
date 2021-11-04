//
//  ItemsUseCase.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 07/01/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import Combine

final class ItemsUseCase: UseCase<Item.Kind, AnyPublisher<[Item], Error>> {

	private let repository: ItemRepository

	init(repository: ItemRepository) {
		self.repository = repository
	}

	// MARK: - UseCase

	override func execute(_ query: Item.Kind) -> AnyPublisher<[Item], Error> {
		return repository.remote(items: query)
	}
}
