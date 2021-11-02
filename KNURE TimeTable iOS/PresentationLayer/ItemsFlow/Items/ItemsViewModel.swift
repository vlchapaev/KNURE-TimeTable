//
//  ItemsViewModel.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 01/01/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import Foundation

final class ItemsViewModel {

	static let cellId = "Item.Kind"

	var sections: [Section] = []

	struct Section {
		let name: String
		let models: [Model]
	}
}

extension ItemsViewModel {

	struct Model {
		let identifier: String
		let text: String
		var updated: Date?
	}
}
