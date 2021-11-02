//
//  SaveItemUseCase.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

final class SaveItemUseCase: UseCase<Item, Void> {

	private let repository: ItemRepository

	init(repository: ItemRepository) {
		self.repository = repository
	}

	// MARK: - UseCase

	override func execute(_ query: Item) {
		let item = query.toDictionary()
		repository.local(save: [item])
	}
}
