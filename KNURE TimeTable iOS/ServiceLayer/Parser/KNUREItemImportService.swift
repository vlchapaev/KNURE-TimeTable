//
//  KNUREItemImportService.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 08/08/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import CoreData

class KNUREItemImportService: ImportService {

	private let persistentContainer: NSPersistentContainer

	init(persistentContainer: NSPersistentContainer) {
		self.persistentContainer = persistentContainer
	}

	func importData(_ data: Data?, _ completion: () -> Void) throws {
		try importData(data, transform: { _ in }, completion: completion)
	}

	func importData(_ data: Data?,
					transform: @escaping (inout [AnyHashable: Any]) -> Void,
					completion: () -> Void) throws {
		// TODO: implement
	}

}
