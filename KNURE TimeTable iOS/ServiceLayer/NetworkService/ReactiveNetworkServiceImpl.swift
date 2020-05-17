//
//  ReactiveNetworkServiceImpl.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 30/03/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import RxSwift
import Foundation

final class ReactiveNetworkServiceImpl: ReactiveNetworkService {

	private let session: URLSession

	init(configuration: URLSessionConfiguration = .default) {
		session = URLSession(configuration: configuration)
	}

	// MARK: - PromisedNetworkService

	func execute(_ request: NetworkRequest) -> Observable<NetworkResponse> {
		return session.rx.response(request: request.urlRequest)
			.map {
				let status = HTTP.Status(code: $0.response.statusCode)
				return NetworkResponse(status: status, data: $0.data)
			}
			.observeOn(MainScheduler.instance)
	}
}
