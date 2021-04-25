//
//  ContainerTests.swift
//  KNURE TimeTable iOS Tests
//
//  Created by Vladislav Chapaev on 25/04/2021.
//  Copyright © 2021 Vladislav Chapaev. All rights reserved.
//

import XCTest
@testable import KNURE_TimeTable_iOS

final class ContainerTests: XCTestCase {

	var sut: Container!

	private final class MockClass {}

    override func setUp() {
		super.setUp()
		sut = Container()
	}

    override func tearDown() {
		sut = nil
		super.tearDown()
	}

	func testRegistratonCount() {
		// act
		sut.register(String.self) { _ in return "123" }
		sut.register(String.self) { _ in return "123" }
		sut.register(String.self) { _ in return "123" }

		// act
		XCTAssertEqual(sut.storage.count, 1)
	}

	func testSharedScope() {
		// arrange
		sut.register(MockClass.self, in: .shared) { _ in return MockClass() }

		// act
		let result1 = XCTAssertNoRethrow(try sut.resolve(MockClass.self))
		let result2 = XCTAssertNoRethrow(try sut.resolve(MockClass.self))

		// assert
		XCTAssertTrue(result1 === result2)
		XCTAssertEqual(sut.storage.count, 1)
	}

	func testGraphScope() {
		// arrange
		sut.register(MockClass.self, in: .graph) { _ in return MockClass() }

		// act
		let result1 = XCTAssertNoRethrow(try sut.resolve(MockClass.self))
		let result2 = XCTAssertNoRethrow(try sut.resolve(MockClass.self))

		// assert
		XCTAssertTrue(result1 === result2)
		XCTAssertEqual(sut.storage.count, 1)
	}

	func testOnDestroyShouldClearAllRegistrations() {
		// arrange
		sut.register(MockClass.self, in: .shared) { _ in return MockClass() }

		// act
		XCTAssertNoThrow(try sut.resolve(MockClass.self))
		XCTAssertEqual(sut.storage.count, 1)
		sut.storage.destroy()

		// assert
		XCTAssertEqual(sut.storage.count, 0)
		XCTAssertThrowsError(try sut.resolve(MockClass.self))
	}
}
