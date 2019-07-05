//
//  PromisedNetworkServiceImpl.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 30/03/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import PromiseKit

class PromisedNetworkServiceImpl: PromisedNetworkService {

	private let configuration: URLSessionConfiguration

	init(configuration: URLSessionConfiguration = .default) {
		self.configuration = configuration
	}

	// MARK: - PromisedNetworkService

	func execute(_ request: NetworkRequest) -> Promise<NetworkResponse> {
		return Promise { [weak self] (resolver: Resolver<NetworkResponse>) in
			guard let self = self else { resolver.reject(ApplicationLayerError.nilSelfError); return }
			let session = URLSession(configuration: self.configuration)
			let completion = self.makeSessionCompletion(resolver: resolver,
														shouldConvertToJson: request.shouldConvertResponseToJSON)
			session.dataTask(with: request.defaultUrlRequest,
							 completionHandler: completion).resume()
		}
	}

	func makeSessionCompletion(resolver: Resolver<NetworkResponse>,
							   shouldConvertToJson: Bool) -> (Data?, URLResponse?, Error?) -> Void {
		return { data, urlResponse, error in

			guard let statusCode = (urlResponse as? HTTPURLResponse)?.statusCode else {
				resolver.reject(HTTPStatus.undefined)
				return
			}

			let httpStatus = HTTPStatus(code: statusCode)
			var json: Any?

			if let data = data, shouldConvertToJson {
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
