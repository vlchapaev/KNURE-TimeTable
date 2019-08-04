//
//  Convertable.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 04/06/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import CoreData

protocol DomainConvertable: AnyObject {
	associatedtype DomainType

	var domainValue: DomainType { get }
}

protocol DataConvertable: AnyObject {
	associatedtype DataType

	func dataType(context: NSManagedObjectContext) -> DataType
}
