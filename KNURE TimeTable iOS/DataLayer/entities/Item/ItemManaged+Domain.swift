//
//  ItemManaged+Domain.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 04/06/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import Foundation

extension ItemManaged: Convertable {
	typealias NewType = Item

	var newValue: Item {
		let timetableType: Item.Kind = Item.Kind(rawValue: type?.intValue ?? 0) ?? .group
		var item = Item(identifier: identifier ?? "0",
						shortName: title ?? "",
						fullName: fullName,
						type: timetableType)

		if let lastUpdateTimestamp = lastUpdateTimestamp?.doubleValue {
			item.lastUpdate = Date(timeIntervalSince1970: lastUpdateTimestamp)
		}

		return item
	}
}
