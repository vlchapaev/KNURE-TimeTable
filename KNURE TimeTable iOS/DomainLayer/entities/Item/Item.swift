//
//  Item.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import Foundation

/// Item is the representation of entity than can contain timetable, such as group, teacher or auditory
public class Item {

	/// unique value to store item
	var identifier: NSNumber

	/// short name to represent entity
	var shortName: String

	/// full name to represent, such as full name of teacher
	var fullName: String?

	/// group, teacher or auditory
	var type: TimetableItem

	/// date wich specify the last time this item schedule was updated
	var lastUpdate: Date?

	init(identifier: NSNumber, shortName: String, type: TimetableItem) {
		self.identifier = identifier
		self.shortName = shortName
		self.type = type
	}
}

extension ItemManaged {
	func toDomain() -> Item {
		let timetableType: TimetableItem = TimetableItem(rawValue: type?.intValue ?? 0) ?? .group
		let item = Item(identifier: identifier ?? 0,
						shortName: title ?? "",
						type: timetableType)

		if let lastUpdateTimestamp = lastUpdateTimestamp?.doubleValue {
			item.lastUpdate = Date(timeIntervalSince1970: lastUpdateTimestamp)
		}

		if let fullName = fullName {
			item.fullName = fullName
		}

		return item
	}
}
