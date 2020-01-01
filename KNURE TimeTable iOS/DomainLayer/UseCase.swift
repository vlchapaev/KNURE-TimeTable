//
//  UseCase.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 12/05/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

/// UseCase represent basic unit of bisness logic
class UseCase<Query, Response> {

	/// command to execute use case
	///
	/// - Parameter query: input type
	/// - Returns: promise output type
	func execute(_ query: Query) -> Response {
		fatalError("Should override in super class")
	}
}
