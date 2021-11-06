//
//  AddItemsViewModel.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 01/01/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import Combine

final class AddItemsViewModel {

	var selectedType: Item.Kind = .group

	var sections: [Section] = []
	var filtredSections: [Section] = []
	var sourceSections: [Section] = []

	static let cellId = "TimetableAddItem"

	struct Section {
		let title: String?
		let models: [Model]
	}

	struct Model {
		let identifier: String
		let text: String
		let selected: Bool
	}

	var subscriptions: [AnyCancellable] = []
}

extension AddItemsViewModel.Section: Comparable {
	static func < (lhs: AddItemsViewModel.Section, rhs: AddItemsViewModel.Section) -> Bool {
		return lhs.title ?? "" < rhs.title ?? ""
	}

	static func == (lhs: AddItemsViewModel.Section, rhs: AddItemsViewModel.Section) -> Bool {
		return lhs.title == rhs.title
	}
}
