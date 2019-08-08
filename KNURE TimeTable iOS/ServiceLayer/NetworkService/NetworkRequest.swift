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
	var urlParams: [AnyHashable: Any]?
	var httpHeaders: [AnyHashable: Any]?
	var httpBody: Data?
	var shouldConvertResponseToJSON: Bool

	init(url: URL) {
		self.url = url
		httpMethod = .GET
		shouldConvertResponseToJSON = true
	}

	var urlRequest: URLRequest {
		return makeUrlRequest(HTTPMethod: httpMethod.rawValue,
							  url: url,
							  urlParameters: urlParams,
							  httpBody: httpBody,
							  httpHeaders: httpHeaders)
	}

	private func makeUrlRequest(HTTPMethod: String,
								url: URL,
								urlParameters: [AnyHashable: Any]?,
								httpBody: Data?,
								httpHeaders: [AnyHashable: Any]?) -> URLRequest {

		var urlRequest: URLRequest

		var urlPath = url.absoluteString
		if let urlParameters = urlParameters {
			let parameters: String = urlParameters.map({ "\($0.key)=\($0.value)" }).joined(separator: "&")
			if parameters.isEmpty == false {
				urlPath += "?\(parameters)"
			}
		}

		urlRequest = URLRequest(url: URL(string: urlPath)!)

		urlRequest.httpMethod = HTTPMethod
		urlRequest.httpBody = httpBody

		if let headers = httpHeaders {
			headers.forEach { urlRequest.setValue("\($0)", forHTTPHeaderField: "\($1)") }
		}

		return urlRequest
	}
}

enum Networking: Error {
	case invalidUrlError
	case nilResponseDataError
}
