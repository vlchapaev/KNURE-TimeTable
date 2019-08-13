//
//  NetworkRequest.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 30/03/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
	case GET
	case POST
	case PUT
	case PATCH
	case DELETE
}

struct NetworkRequest {
	var httpMethod: HTTPMethod
	var url: URL
	var httpHeaders: [AnyHashable: Any]?
	var httpBody: Data?
	var shouldConvertResponseToJSON: Bool

	init(url: URL,
		 httpMethod: HTTPMethod = .GET,
		 shouldConvertResponseToJSON: Bool = true) {
		self.url = url
		self.httpMethod = httpMethod
		self.shouldConvertResponseToJSON = shouldConvertResponseToJSON
	}

	var urlRequest: URLRequest {
		return makeUrlRequest(HTTPMethod: httpMethod.rawValue,
							  url: url,
							  httpBody: httpBody,
							  httpHeaders: httpHeaders)
	}

	private func makeUrlRequest(HTTPMethod: String,
								url: URL,
								httpBody: Data?,
								httpHeaders: [AnyHashable: Any]?) -> URLRequest {

		var urlRequest = URLRequest(url: url)

		urlRequest.httpMethod = HTTPMethod
		urlRequest.httpBody = httpBody

		if let headers = httpHeaders {
			headers.forEach { urlRequest.setValue("\($1)", forHTTPHeaderField: "\($0)") }
		}

		return urlRequest
	}
}
