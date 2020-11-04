//
//  ItemsInteractor.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 01/01/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

protocol ItemsInteractorInput {

//	func obtainItems() -> Observable<[ItemsViewModel.Section]>

	func removeItem(identifier: String)
}

final class ItemsInteractor: ItemsInteractorInput {

	private let removeItemUseCase: RemoveItemUseCase
	private let selectedItemsUseCase: SelectedItemsUseCase

	init(removeItemUseCase: RemoveItemUseCase,
		 selectedItemsUseCase: SelectedItemsUseCase) {
		self.removeItemUseCase = removeItemUseCase
		self.selectedItemsUseCase = selectedItemsUseCase
	}

	// MARK: - ItemsInteractorInput

//	func obtainItems() -> Observable<[ItemsViewModel.Section]> {
//		selectedItemsUseCase.execute(()).map {
//			let items = ("Groups", $0.filter { $0.type == .group })
//			let teachers = ("Teachers", $0.filter { $0.type == .teacher })
//			let auditories = ("Auditories", $0.filter { $0.type == .auditory })
//
//			return [items, teachers, auditories]
//				.filter { !$0.1.isEmpty }
//				.map { ItemsViewModel.Section(name: $0.0, models: $0.1) }
//		}
//	}

	func removeItem(identifier: String) {
		_ = removeItemUseCase.execute(identifier)
	}
}
