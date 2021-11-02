//
//  RemoveItemUseCase.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

final class RemoveItemUseCase: UseCase<String, Void> {

	private let repository: ItemRepository

	init(repository: ItemRepository) {
		self.repository = repository
	}

	//	 MARK: - UseCase

	override func execute(_ query: String) {
		repository.local(delete: query)
	}
}
