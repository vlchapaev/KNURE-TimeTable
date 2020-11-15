//
//  KNURE.Response.Groups.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 04/11/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

extension KNURE.Response.University.Faculty {
	struct Direction: Decodable {
		let id: Int
		let short_name: String // swiftlint:disable:this identifier_name
		let full_name: String // swiftlint:disable:this identifier_name
		@IgnoreFailable var groups: [Group]
		@IgnoreFailable var specialities: [Speciality]
	}
}

extension KNURE.Response.University.Faculty.Direction {
	struct Speciality: Decodable {
		let id: Int
		let short_name: String // swiftlint:disable:this identifier_name
		let full_name: String // swiftlint:disable:this identifier_name
		@IgnoreFailable var groups: [Group]
	}

	struct Group: Decodable {
		let id: Int
		let name: String
	}
}
