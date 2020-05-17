//
//  AddItemsViewModel.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 01/01/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import RxCocoa

final class AddItemsViewModel {
	var items: BehaviorRelay<[Model]>
	var selectedType: Item.Kind

	static let cellId = "TimetableAddItem"

	struct Model {
		let identifier: String
		let text: String
		let selected: Bool
	}

	init() {
		items = BehaviorRelay(value: [])
		selectedType = .group
	}
}
