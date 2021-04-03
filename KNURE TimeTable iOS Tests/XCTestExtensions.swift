//
//  XCTestExtensions.swift
//  KNURE TimeTable iOS Tests
//
//  Created by Vladislav Chapaev on 03/04/2021.
//  Copyright © 2021 Vladislav Chapaev. All rights reserved.
//

import XCTest

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
