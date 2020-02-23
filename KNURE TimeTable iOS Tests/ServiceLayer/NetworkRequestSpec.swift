//
//  NetworkRequestSpec.swift
//  KNURE TimeTable iOS Tests
//
//  Created by Vladislav Chapaev on 22/09/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import Quick
import Nimble
@testable import KNURE_TimeTable_iOS

final class NetworkRequestSpec: QuickSpec {

	override func spec() {

		describe("NetworkRequest") {

			context("when default init") {

				it("should be GET request") {

					let request = NetworkRequest(url: URL(string: "google.com")!).urlRequest
					expect(request.httpMethod).to(equal("GET"))
				}
			}

			context("when make url request") {

				it("should create correct URLRequest") {

					let headers = ["key1": "value1", "key2": "value2", "key3": "value3"]
					let request = NetworkRequest(url: URL(string: "google.com")!, headers: headers)
					let urlRequest = request.urlRequest
					expect(urlRequest.allHTTPHeaderFields).to(equal(headers))
				}
			}
		}
	}
}
