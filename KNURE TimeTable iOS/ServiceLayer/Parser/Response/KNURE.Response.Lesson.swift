//
//  KNURE.Response.Lesson.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 15/11/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import Foundation

extension KNURE.Response {
	struct Lesson: Decodable {
		@IgnoreFailable var events: [Event]
		@IgnoreFailable var subjects: [Subject]
		@IgnoreFailable var groups: [University.Faculty.Direction.Group]
		@IgnoreFailable var teachers: [University.Faculty.Department.Teacher]
		@IgnoreFailable var types: [Type]
	}
}

extension KNURE.Response.Lesson {
	struct Event: Decodable {
		let subject_id: Int // swiftlint:disable:this identifier_name
		let start_time: TimeInterval // swiftlint:disable:this identifier_name
		let end_time: TimeInterval // swiftlint:disable:this identifier_name
		let type: Int
		let number_pair: Int // swiftlint:disable:this identifier_name
		let auditory: String
		let teachers: [Int]
		let groups: [Int]
	}

	struct Subject: Decodable {
		let id: Int // swiftlint:disable:this identifier_name
		let brief: String
		let title: String
		@IgnoreFailable var hours: [Hour]
	}

	struct `Type`: Decodable {
		let id: Int // swiftlint:disable:this identifier_name
		let short_name: String // swiftlint:disable:this identifier_name
		let full_name: String // swiftlint:disable:this identifier_name
		let id_base: Int // swiftlint:disable:this identifier_name
		let type: String
	}
}

extension KNURE.Response.Lesson.Subject {
	struct Hour: Decodable {
		let type: Int
		let val: Int
		let teachers: [Int]
	}
}
