//
//  ImportService.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 08/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import CoreData

/// Provide basic interface for any timetable parsers
/// DI should resolve this interface with implementation for university timetable
/// the goal of parser is to parse timetable of any format to local data model
public protocol ImportService {

	func importData(_ data: Data?, _ completion: () -> Void) throws
}
