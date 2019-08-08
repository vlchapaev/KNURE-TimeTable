//
//  Item.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import Foundation

/// Basic item types in list
enum TimetableItem: Int {

	case group = 1, teacher, auditory
}

/// Item is the representation of entity than can contain timetable, such as group, teacher or auditory
class Item {

	/// unique value to store item
	let identifier: String

	/// short name to represent entity
	let shortName: String

	/// full name to represent, such as full name of teacher
	var fullName: String?

	/// group, teacher or auditory
	let type: TimetableItem

	/// date wich specify the last time this item schedule was updated
	var lastUpdate: Date?

	init(identifier: String,
		 shortName: String,
		 type: TimetableItem) {
		self.identifier = identifier
		self.shortName = shortName
		self.type = type
	}
}
