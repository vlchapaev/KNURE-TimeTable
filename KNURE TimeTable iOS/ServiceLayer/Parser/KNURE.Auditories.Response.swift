//
//  KNURE.Auditories.Response.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 04/11/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

extension KNURE {
	struct Auditories { }
}

extension KNURE.Auditories {
	struct Response: Decodable {
		let university: University
	}
}

extension KNURE.Auditories.Response {
	struct University: Decodable {
		@IgnoreFailable var buildings: [Building]
	}
}

extension KNURE.Auditories.Response.University {
	struct Building: Decodable {
		let id: String
		let short_name: String // swiftlint:disable:this identifier_name
		let full_name: String // swiftlint:disable:this identifier_name
		@IgnoreFailable var auditories: [Auditory]
	}
}

extension KNURE.Auditories.Response.University.Building {
	struct Auditory: Decodable {
		let id: String
		let short_name: String // swiftlint:disable:this identifier_name
	}
}
