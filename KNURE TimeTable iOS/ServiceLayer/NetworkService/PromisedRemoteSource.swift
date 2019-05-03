//
//  PromisedRemoteSource.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 30/03/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import PromiseKit

class PromisedRemoteSource: RemoteSource {

	var session: URLSession
	var queue: DispatchQueue

	init(configuration: URLSessionConfiguration) {
		session = URLSession(configuration: configuration)
		queue = DispatchQueue(label: "com.NetworkSession.queue")
	}

	// MARK: - RemoteSource

	func execute(_ request: NetworkRequest) -> Promise<NetworkResponse> {
		return Promise(resolver: { (resolver: Resolver<NetworkResponse>) in
			self.session.dataTask(with: request.defaultUrlRequest,
								  completionHandler: self.makeSessionCompletion(resolver: resolver)).resume()
		})
	}

	func makeSessionCompletion(resolver: Resolver<NetworkResponse>) -> (Data?, URLResponse?, Error?) -> Void {
		return { data, urlResponse, error in

			guard let statusCode = (urlResponse as? HTTPURLResponse)?.statusCode else {
				resolver.reject(HTTPStatusNotResolvedError())
				return
			}

			let httpStatus = HTTPStatus(code: statusCode)
			var json: Any?

			if let data = data {
				do {
					json = try JSONSerialization.jsonObject(with: data, options: [])
				} catch {
					resolver.reject(error)
				}
			}

			let response = NetworkResponse(httpStatus: httpStatus, data: data, json: json)
			resolver.fulfill(response)
		}
	}
}

class HTTPStatusNotResolvedError: Error {}
