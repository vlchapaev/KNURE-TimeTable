//
//  ImportService.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 08/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import Foundation

/// Provide basic interface for data import
/// DI should resolve this interface with implementation for specific data model
public protocol ImportService {

	/// Import data with completion
	///
	/// - Parameters:
	///   - data: data to import
	///   - completion: signal for import is over
	/// - Returns: Void
	/// - Throws: throws error if something goes wrong
	func importData(_ data: Data?, _ completion: () -> Void) throws

	/// Import data with option to transform dictionary in the process
	///
	/// - Parameters:
	///   - data: data to import
	///   - transform: transform some data during import
	///   - completion: signal for import is over
	/// - Throws: throws error if something goes wrong
	func importData(_ data: Data?,
					transform: @escaping (inout [AnyHashable: Any]) -> Void,
					completion: () -> Void) throws
}

enum ImportServiceError: LocalizedError {
	case nilData
	case missing(String)

	var errorDescription: String? {
		switch self {
		case .missing(let key):
			return "Error: missing value for key named: \(key)!"

		case .nilData:
			return "Can't find any value"
		}
	}
}
