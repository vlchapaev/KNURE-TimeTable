//
//  Item.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import Foundation

/// Item is the representation of entity than can contain timetable, such as group, teacher or auditory
protocol Item {

	/// unique value to store item
	var identifier: String { get }

	/// short name to represent entity
	var shortName: String { get }

	/// full name to represent, such as full name of teacher
	var fullName: String? { get }

	/// group, teacher or auditory
	var type: TimetableItem { get }

	/// date wich specify the last time this item schedule was updated
	var lastUpdate: Date? { get }
}
