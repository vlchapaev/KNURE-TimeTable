//
//  ItemManaged+Domain.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 04/06/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import Foundation

extension ItemManaged: DomainConvertable {
	public typealias DomainType = Item

	public var domainValue: Item {
		return Item(identifier: identifier ?? 0,
					shortName: title ?? "",
					type: .group)
	}

//	var domainValue: Item {
//		return Item(identifier: identifier ?? 0,
//					shortName: title ?? "",
//					type: .group)
//	}
}
