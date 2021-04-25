//
//  XCTestExtensions.swift
//  KNURE TimeTable iOS Tests
//
//  Created by Vladislav Chapaev on 03/04/2021.
//  Copyright © 2021 Vladislav Chapaev. All rights reserved.
//

import XCTest
import Combine

public func XCTAssertNoRethrow<T>(_ expression: @autoclosure () throws -> T,
								  _ message: @autoclosure () -> String = "",
								  file: StaticString = #file,
								  line: UInt = #line) -> T {
	do {
		return try expression()
	} catch {
		let message = (error as NSError).debugDescription
		XCTFail(message, file: file, line: line)
		fatalError(message)
	}
}

extension XCTestCase {
	func await<T: Publisher>(_ publisher: T,
							 timeout: TimeInterval = 0.1,
							 file: StaticString = #file,
							 line: UInt = #line) throws -> T.Output {
		var result: Result<T.Output, Error>?
        let expectation = self.expectation(description: "Awaiting publisher")

		let cancellable = publisher
			.sink(receiveCompletion: { completion in
				switch completion {
					case .failure(let error):
						result = .failure(error)

					case .finished:
						break
				}

				expectation.fulfill()

			}, receiveValue: { value in
				result = .success(value)
			})

        waitForExpectations(timeout: timeout)
        cancellable.cancel()

		let unwrappedResult = try XCTUnwrap(result,
											"Awaited publisher did not produce any output",
											file: file,
											line: line)

        return try unwrappedResult.get()
    }
}
