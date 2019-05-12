//
//  UseCase.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 12/05/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import PromiseKit

/// UseCase represent basic unit of bisness logic
public protocol UseCase {
	associatedtype Query
	associatedtype Response

	/// command to execute use case
	///
	/// - Parameter query: input type
	/// - Returns: promise output type
	func execute(_ query: Query) -> Promise<Response>
}
