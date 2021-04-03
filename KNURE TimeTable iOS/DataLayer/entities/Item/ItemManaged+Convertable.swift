//
//  ItemManaged+Convertable.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 04/06/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import Foundation

extension ItemManaged: Convertable {
	typealias NewType = Item

	func convert() -> Item? {
		let timetableType = Item.Kind(rawValue: Int(type)) ?? .group

		var item = Item(identifier: identifier!,
						shortName: title!,
						fullName: fullName,
						type: timetableType)

		item.lastUpdate = Date(timeIntervalSince1970: lastUpdateTimestamp)

		return item
	}
}
