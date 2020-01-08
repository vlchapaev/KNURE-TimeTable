//
//  NetworkResponse.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 30/03/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import Foundation

struct NetworkResponse {
	var httpStatus: HTTPStatus
	var data: Data?

	init(httpStatus: HTTPStatus,
		 data: Data? = nil) {
		self.httpStatus = httpStatus
		self.data = data
	}
}
