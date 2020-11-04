//
//  KNURE.Teachers.Response.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 04/11/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

extension KNURE {
	struct Teachers { }
}

extension KNURE.Teachers {
	struct Response: Decodable {
		let university: University
	}
}

extension KNURE.Teachers.Response {
	struct University: Decodable {
		@IgnoreFailable var faculties: [Faculty]
	}
}

extension KNURE.Teachers.Response.University {
	struct Faculty: Decodable {
		let id: Int
		let short_name: String // swiftlint:disable:this identifier_name
		let full_name: String // swiftlint:disable:this identifier_name
		@IgnoreFailable var departments: [Department]
	}
}

extension KNURE.Teachers.Response.University.Faculty {
	struct Department: Decodable {
		let id: Int
		let short_name: String // swiftlint:disable:this identifier_name
		let full_name: String // swiftlint:disable:this identifier_name
		@IgnoreFailable var teachers: [Teacher]
	}
}

extension KNURE.Teachers.Response.University.Faculty.Department {
	struct Teacher: Decodable {
		let id: Int
		let short_name: String // swiftlint:disable:this identifier_name
		let full_name: String // swiftlint:disable:this identifier_name
	}
}
