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

	func local(save item: Item) {
		// TODO: implement
	}

	func local(delete identifier: String) {
		// TODO: implement
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
			.tryMap { element -> Data in
				guard element.status == .ok else { throw element.status }
				return element.data
		}
		.decode(type: KNURE.Response.self, decoder: decoder)
		.map {
			switch type {
				case .group: return $0.university.groups
				case .teacher: return $0.university.teachers
				case .auditory: return $0.university.auditories
			}
		}
		.eraseToAnyPublisher()
	}
}
