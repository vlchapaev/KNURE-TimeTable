//
//  Convertable.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 04/06/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

protocol Convertable: AnyObject {
	associatedtype NewType

	var newValue: NewType { get }
}
