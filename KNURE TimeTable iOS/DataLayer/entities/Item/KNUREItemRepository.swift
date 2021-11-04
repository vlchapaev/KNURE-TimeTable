//
//  KNUREItemRepository.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import CoreData
import Combine

final class KNUREItemRepository: ItemRepository {

	private let coreDataService: CoreDataService
	private let networkService: NetworkService

	init(coreDataService: CoreDataService,
		 networkService: NetworkService) {
		self.coreDataService = coreDataService
		self.networkService = networkService
	}

	func localSelectedItems() -> AnyPublisher<[Item], Error> {
		let request = NSFetchRequest<ItemManaged>(entityName: "ItemManaged")
		request.predicate = NSPredicate(format: "selected = %@", NSNumber(value: true))
		request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
		return coreDataService.observe(request)
	}

	func local(save items: [[String: Any]]) {
		let request = NSBatchInsertRequest(entity: ItemManaged.entity(), objects: items)
		request.resultType = .objectIDs
		coreDataService.save(request)
	}

	func local(delete identifier: String) {
		let request = NSFetchRequest<ItemManaged>(entityName: "ItemManaged")
		request.predicate = NSPredicate(format: "identifier = %@", identifier)
		coreDataService.delete(request)
	}

	func remote(items type: Item.Kind) -> AnyPublisher<[Item], Error> {
		let request: URLRequest
		do {
			request = try KNURE.Request.make(endpoint: .item(type))
		} catch {
			return Fail(error: error).eraseToAnyPublisher()
		}

		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		return networkService.execute(request)
			.tryMap(handle)
			.tryMap { try $0.transform(from: .windowsCP1251, to: .utf8) }
			.decode(type: KNURE.Response.self, decoder: decoder)
			.map { self.transform(response: $0, by: type) }
			.eraseToAnyPublisher()
	}
}

private extension KNUREItemRepository {
	func handle(_ response: NetworkResponse) throws -> Data {
		guard response.status == .ok else { throw response.status }
		return response.data
	}

	func transform(response: KNURE.Response, by type: Item.Kind) -> [Item] {
		switch type {
		case .group:
			return response.university.groups
		case .teacher:
			return response.university.teachers
		case .auditory:
			return response.university.auditories
		}
	}
}
