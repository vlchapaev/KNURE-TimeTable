//
//  SelectedItemsUseCase.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import Combine

final class SelectedItemsUseCase: UseCase<Void, AnyPublisher<[Item], Never>> {

	private let repository: ItemRepository

	init(repository: ItemRepository) {
		self.repository = repository
	}

	// MARK: - UseCase

	override func execute(_ query: Void) -> AnyPublisher<[Item], Never> {
		return repository.localSelectedItems()
	}
}
