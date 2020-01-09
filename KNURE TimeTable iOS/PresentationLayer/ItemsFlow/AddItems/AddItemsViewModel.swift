//
//  AddItemsViewModel.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 01/01/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import RxCocoa

final class AddItemsViewModel {
	var items: BehaviorRelay<[Item]>
	var selectedType: TimetableItem

	static let cellId = "TimetableAddItem"

	init() {
		items = BehaviorRelay(value: [])
		selectedType = .group
	}
}
