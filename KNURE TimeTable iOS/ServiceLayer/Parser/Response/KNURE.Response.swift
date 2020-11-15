//
//  KNURE.Response.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 15/11/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

extension KNURE {
	struct Response: Decodable {
		let university: University
	}
}

extension KNURE.Response {
	struct University: Decodable {
		let faculties: [Faculty]
		let buildings: [Building]

		init(from decoder: Decoder) throws {
			let container = try decoder.container(keyedBy: CodingKeys.self)

			faculties = (try? container.decode([Throwable<Faculty>].self, forKey: .faculties)
				.compactMap { try? $0.result.get() }) ?? []

			buildings = (try? container.decode([Throwable<Building>].self, forKey: .buildings)
				.compactMap { try? $0.result.get() }) ?? []
		}
	}
}

extension KNURE.Response.University {
	enum CodingKeys: CodingKey {
		case faculties, buildings
	}
}

extension KNURE.Response.University {
	struct Faculty: Decodable {
		let id: Int
		let short_name: String // swiftlint:disable:this identifier_name
		let full_name: String // swiftlint:disable:this identifier_name
		let directions: [Direction]
		let departments: [Department]

		init(from decoder: Decoder) throws {
			let container = try decoder.container(keyedBy: CodingKeys.self)

			id = try container.decode(Int.self, forKey: .id)
			short_name = try container.decode(String.self, forKey: .short_name)
			full_name = try container.decode(String.self, forKey: .full_name)

			directions = (try? container.decode([Throwable<Direction>].self, forKey: .directions)
				.compactMap { try? $0.result.get() }) ?? []

			departments = (try? container.decode([Throwable<Department>].self, forKey: .departments)
				.compactMap { try? $0.result.get() }) ?? []
		}
	}
}

extension KNURE.Response.University.Faculty {
	enum CodingKeys: CodingKey {
		case id, short_name, full_name, directions, departments // swiftlint:disable:this identifier_name
	}
}
