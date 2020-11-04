//
//  ItemsViewModel.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 01/01/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import Foundation

final class ItemsViewModel {

//	var sections: BehaviorRelay<[Section]>

	static let cellId = "Item.Kind"

	struct Section {
		let name: String
		let models: [Item]
	}

	init() {
//		sections = BehaviorRelay(value: [])
	}
}

//extension ItemsViewModel.Section: SectionModelType {
//	typealias Item = KNURE_TimeTable_iOS.Item
//
//	init(original: ItemsViewModel.Section, items: [Item]) {
//		name = original.name
//		models = original.items
//	}
//
//	var items: [Item] {
//		return models
//	}
//}
