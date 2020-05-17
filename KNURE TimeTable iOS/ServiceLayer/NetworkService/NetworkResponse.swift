//
//  NetworkResponse.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 30/03/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import Foundation

struct NetworkResponse {

	var status: HTTP.Status
	var data: Data?

	init(status: HTTP.Status,
		 data: Data? = nil) {
		self.status = status
		self.data = data
	}
}
