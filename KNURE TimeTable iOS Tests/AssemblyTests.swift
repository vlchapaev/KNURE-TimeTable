//
//  AssemblyTests.swift
//  KNURE TimeTable iOS Tests
//
//  Created by Vladislav Chapaev on 04/11/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import XCTest
@testable import KNURE_TimeTable_iOS

final class AssemblyTests: XCTestCase {

	var sut: Container!

	override func setUp() {
		super.setUp()
		sut = Container.shared
	}

	override func tearDown() {
		sut = nil
		super.tearDown()
	}

	func testApplicationLayerAssembler() {
		// arrange
		XCTAssertNoThrow(try ApplicationLayerAssembly().assemble(container: sut))

		// act & assert
		XCTAssertNoThrow(try sut.resolve(Configuration.self))
	}

	func testServiceLayerAssembler() {
		// arrange
		let assembly: [Assembly] = [ApplicationLayerAssembly(), ServiceLayerAssembly()]
		XCTAssertNoThrow(try assembly.forEach { try $0.assemble(container: sut) })

		// act & assert
		XCTAssertNoThrow(try sut.resolve(CoreDataService.self))
		XCTAssertNoThrow(try sut.resolve(ImportService.self, named: "KNURE_Lesson"))
		XCTAssertNoThrow(try sut.resolve(NetworkService.self))
	}

	func testDataLayerAssembler() {
		// arrange
		let assembly: [Assembly] = [
			ApplicationLayerAssembly(),
			ServiceLayerAssembly(),
			DataLayerAssembly()
		]
		XCTAssertNoThrow(try assembly.forEach { try $0.assemble(container: sut) })

		// act & assert
		XCTAssertNoThrow(try sut.resolve(ItemRepository.self, named: "KNURE"))
		XCTAssertNoThrow(try sut.resolve(LessonRepository.self, named: "KNURE"))
	}

	func testDomainLayerAssembler() {
		// arrange
		let assembly: [Assembly] = [
			ApplicationLayerAssembly(),
			ServiceLayerAssembly(),
			DataLayerAssembly(),
			DomainLayerAssembly()
		]
		XCTAssertNoThrow(try assembly.forEach { try $0.assemble(container: sut) })

		// act & assert
		XCTAssertNoThrow(try sut.resolve(ItemsUseCase.self))
		XCTAssertNoThrow(try sut.resolve(SaveItemUseCase.self))
		XCTAssertNoThrow(try sut.resolve(RemoveItemUseCase.self))
		XCTAssertNoThrow(try sut.resolve(SelectedItemsUseCase.self))

		XCTAssertNoThrow(try sut.resolve(UpdateTimetableUseCase.self))
	}
}
