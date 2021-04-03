//
//  NetworkService.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 27/02/2021.
//  Copyright © 2021 Vladislav Chapaev. All rights reserved.
//

import Combine
import Foundation

final class NetworkService {

	private let session: URLSession

	init(configuration: URLSessionConfiguration = .default) {
		session = .init(configuration: configuration, delegate: nil, delegateQueue: nil)
	}

	func execute(_ request: URLRequest) -> AnyPublisher<NetworkResponse, URLError> {
		session.dataTaskPublisher(for: request)
			.compactMap(transform)
			.eraseToAnyPublisher()
	}

	private func transform(data: Data, response: URLResponse) -> NetworkResponse? {
		guard let status = response as? HTTPURLResponse,
			let statusCode = HTTP.Status(rawValue: status.statusCode) else {
				return nil
		}

		return NetworkResponse(status: statusCode, data: data)
	}
}

struct NetworkResponse {
	let status: HTTP.Status
	let data: Data
}
