//
//  AssemblyTests.swift
//  KNURE TimeTable iOS Tests
//
//  Created by Vladislav Chapaev on 04/11/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import XCTest
import Swinject
@testable import KNURE_TimeTable_iOS

final class AssemblyTests: XCTestCase {

	var sut: Container!

	override func setUp() {
		super.setUp()
		sut = Container()
	}

	override func tearDown() {
		sut = nil
		super.tearDown()
	}

	func testApplicationLayerAssembler() {
		// arrange
		ApplicationLayerAssembly().assemble(container: sut)

		// act & assert
		XCTAssertNotNil(sut.resolve(ApplicationConfig.self))
	}

	func testServiceLayerAssembler() {
		// arrange
		let assembly: [Assembly] = [ApplicationLayerAssembly(), ServiceLayerAssembly()]
		assembly.forEach { $0.assemble(container: sut) }

		// act & assert
		XCTAssertNotNil(sut.resolve(CoreDataService.self))
		XCTAssertNotNil(sut.resolve(ReactiveCoreDataService.self))
		XCTAssertNotNil(sut.resolve(ImportService.self, name: "KNURE_Group"))
		XCTAssertNotNil(sut.resolve(ImportService.self, name: "KNURE_Teacher"))
		XCTAssertNotNil(sut.resolve(ImportService.self, name: "KNURE_Auditory"))
	}

	func testDataLayerAssembler() {
		// arrange
		let assembly: [Assembly] = [
			ApplicationLayerAssembly(),
			ServiceLayerAssembly(),
			DataLayerAssembly()
		]
		assembly.forEach { $0.assemble(container: sut) }

		// act & assert
		XCTAssertNotNil(sut.resolve(ItemRepository.self))
		XCTAssertNotNil(sut.resolve(LessonRepository.self))
	}

	func testDomainLayerAssembler() {
		// arrange
		let assembly: [Assembly] = [
			ApplicationLayerAssembly(),
			ServiceLayerAssembly(),
			DataLayerAssembly(),
			DomainLayerAssembly()
		]
		assembly.forEach { $0.assemble(container: sut) }

		// act & assert
		XCTAssertNotNil(sut.resolve(ItemsUseCase.self))
		XCTAssertNotNil(sut.resolve(SaveItemUseCase.self))
		XCTAssertNotNil(sut.resolve(RemoveItemUseCase.self))
		XCTAssertNotNil(sut.resolve(SelectedItemsUseCase.self))

		XCTAssertNotNil(sut.resolve(UpdateTimetableUseCase.self))
	}
}
