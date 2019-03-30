//
//  NetworkResponse.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 30/03/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import Foundation

class NetworkResponse {
	var httpStatus: HTTPStatus
	var data: Data?
	var json: Any?

	init(httpStatus: HTTPStatus, data: Data? = nil, json: Any? = nil) {
		self.httpStatus = httpStatus
		self.data = data
		self.json = json
	}
}
