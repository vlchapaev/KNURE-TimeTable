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
		@Omissible var faculties: [Faculty]
		@Omissible var buildings: [Building]
	}
}

extension KNURE.Response.University {
	struct Faculty: Decodable {
		let id: Int
		let shortName: String
		let fullName: String
		@Omissible var directions: [Direction]
		@Omissible var departments: [Department]
	}
}

extension KNURE.Response.University {
	var groups: [Item] {
		return faculties
			.flatMap { $0.directions }
			.flatMap { $0.groups }
			.map { Item(identifier: "\($0.id)", shortName: $0.name, type: .group) }
	}

	var teachers: [Item] {
		return faculties
			.flatMap { $0.departments }
			.flatMap { $0.teachers }
			.map { Item(identifier: "\($0.id)", shortName: $0.shortName, fullName: $0.fullName, type: .teacher) }
	}

	var auditories: [Item] {
		return buildings
			.flatMap { $0.auditories }
			.map { Item(identifier: $0.id, shortName: $0.shortName, type: .auditory) }
	}
}
