//
//  KNURE.Items.Response.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 04/11/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

extension KNURE {
	struct Items { }
}

extension KNURE.Items {
	struct Response: Decodable {
		let university: University
	}
}

extension KNURE.Items.Response {
	struct University: Decodable {
		@IgnoreFailable var faculties: [Faculty]
	}
}

extension KNURE.Items.Response.University {
	struct Faculty: Decodable {
		let id: Int
		let short_name: String // swiftlint:disable:this identifier_name
		let full_name: String // swiftlint:disable:this identifier_name
		@IgnoreFailable var directions: [Direction]
	}
}

extension KNURE.Items.Response.University.Faculty {
	struct Direction: Decodable {
		let id: Int
		let short_name: String // swiftlint:disable:this identifier_name
		let full_name: String // swiftlint:disable:this identifier_name
		@IgnoreFailable var groups: [Group]
		@IgnoreFailable var specialities: [Speciality]
	}
}

extension KNURE.Items.Response.University.Faculty.Direction {
	struct Group: Decodable {
		let id: Int
		let name: String
	}

	struct Speciality: Decodable {
		let id: Int
		let short_name: String // swiftlint:disable:this identifier_name
		let full_name: String // swiftlint:disable:this identifier_name
		@IgnoreFailable var groups: [Group]
	}
}
