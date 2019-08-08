//
//  PromisedNetworkService.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 30/03/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import PromiseKit

/// URL Service based on Promise
protocol PromisedNetworkService {

	/// Execute network request
	///
	/// - Parameter request: request instance
	/// - Returns: Promise to execute request
	func execute(_ request: NetworkRequest) -> Promise<NetworkResponse>
}
