//
//  Item+Data.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 04/08/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import CoreData

extension Item: DataConvertable {
	typealias DataType = ItemManaged

	func dataType(context: NSManagedObjectContext) -> ItemManaged {
		let object = ItemManaged(context: context)
		object.identifier = identifier
		object.fullName = fullName
		object.lastUpdateTimestamp = lastUpdate?.timeIntervalSince1970 as NSNumber?
		object.title = shortName
		object.type = type.rawValue as NSNumber
		return object
	}
}
