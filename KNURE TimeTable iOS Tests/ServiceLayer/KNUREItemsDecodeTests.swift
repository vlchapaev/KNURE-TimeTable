//
//  KNUREItemsDecodeTests.swift
//  KNURE TimeTable iOS Tests
//
//  Created by Vladislav Chapaev on 11/10/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import XCTest
@testable import KNURE_TimeTable_iOS

final class KNUREItemsDecodeTests: XCTestCase {

    func testValidGroupsJSON() throws {
		// arrange
		let data = MockJSONLoader.load(json: "valid", item: .groups)

		// act
		let response = try JSONDecoder().decode(KNURE.Response.self, from: data)

		// assert
		let faculties = response.university.faculties
		XCTAssertFalse(faculties.isEmpty)
		XCTAssertFalse(faculties.first!.directions.isEmpty)
		XCTAssertFalse(faculties.first!.directions.first!.groups.isEmpty)
	}

	func testImportInvalidGroupsJSON() throws {
		// arrange
		let json = ["university": ["faculties": ["some", "some"]]]
		let data = try JSONSerialization.data(withJSONObject: json)

		// act
		let response = try JSONDecoder().decode(KNURE.Response.self, from: data)

		// assert
		let faculties = response.university.faculties
		XCTAssertTrue(faculties.isEmpty)
	}

	func testValidTeachersJSON() throws {
		// arrange
		let data = MockJSONLoader.load(json: "valid", item: .teachers)

		// act
		let response = try JSONDecoder().decode(KNURE.Response.self, from: data)

		// assert
		let faculties = response.university.faculties
		XCTAssertFalse(faculties.isEmpty)
		XCTAssertFalse(faculties.first!.departments.isEmpty)
		XCTAssertFalse(faculties.first!.departments.first!.teachers.isEmpty)
	}

	func testImportInvalidTeachersJSON() throws {
		// arrange
		let json = ["university": ["faculties": ["some", "some"]]]
		let data = try JSONSerialization.data(withJSONObject: json)

		// act
		let response = try JSONDecoder().decode(KNURE.Response.self, from: data)

		// assert
		let faculties = response.university.faculties
		XCTAssertTrue(faculties.isEmpty)
	}

	func testValidAuditoriesJSON() throws {
		// arrange
		let data = MockJSONLoader.load(json: "valid", item: .auditories)

		// act
		let response = try JSONDecoder().decode(KNURE.Response.self, from: data)

		// assert
		let buildings = response.university.buildings
		XCTAssertFalse(buildings.isEmpty)
		XCTAssertFalse(buildings.first!.auditories.isEmpty)
	}

	func testImportInvalidAuditoriesJSON() throws {
		// arrange
		let json = ["university": ["buildings": ["some", "some"]]]
		let data = try JSONSerialization.data(withJSONObject: json)

		// act
		let response = try JSONDecoder().decode(KNURE.Response.self, from: data)

		// assert
		XCTAssertTrue(response.university.buildings.isEmpty)
	}
}
