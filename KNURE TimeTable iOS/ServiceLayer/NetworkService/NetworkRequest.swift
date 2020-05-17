//
//  NetworkRequest.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 30/03/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import Foundation

struct NetworkRequest {
	private var method: HTTP.Method
	private var url: URL
	private var headers: [AnyHashable: Any]?
	private var body: Data?

	init(url: URL,
		 method: HTTP.Method = .GET,
		 headers: [AnyHashable: Any]? = nil,
		 body: Data? = nil) {
		self.url = url
		self.method = method
		self.headers = headers
		self.body = body
	}

	var urlRequest: URLRequest {

		var urlRequest = URLRequest(url: url)

		urlRequest.httpMethod = method.rawValue
		urlRequest.httpBody = body

		if let headers = headers {
			headers.forEach { urlRequest.setValue("\($1)", forHTTPHeaderField: "\($0)") }
		}

		return urlRequest
	}
}
