//
//  TimetableParser.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 08/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import Foundation

/// Basic item types in list
enum TimetableItem: Int {
    case group = 1, teacher, auditory
}

/// Provide basic interface for any timetable parsers
/// DI should resolve this interface with implementation for university timetable
/// the goal of parser is to parse timetable of any format to local data model
public protocol TimetableParser {

	/// <#Description#>
	///
	/// - Parameters:
	///   - itemId: <#itemId description#>
	///   - data: <#data description#>
	///   - completion: <#completion description#>
	/// - Returns: <#return value description#>
	/// - Throws: <#throws value description#>
	func parseTimetable(identifier: String, data: Data, _ completion: () -> Void) throws

	/// <#Description#>
	///
	/// - Parameters:
	///   - data: <#data description#>
	///   - completion: <#completion description#>
	/// - Throws: <#throws value description#>
	func parseItemList(data: Data, _ completion: () -> Void) throws
}
