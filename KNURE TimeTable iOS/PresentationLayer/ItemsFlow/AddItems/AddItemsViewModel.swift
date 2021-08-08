//
//  AddItemsViewModel.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 01/01/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

final class AddItemsViewModel {

	var selectedType: Item.Kind = .group

	var models: [Model] = []

	static let cellId = "TimetableAddItem"

	struct Model: Hashable {
		let identifier: String
		let text: String
		let selected: Bool
	}
}
