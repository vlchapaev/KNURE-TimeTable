//
//  KNURERequestBuilder.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 23/02/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

import Foundation

struct KNURERequestBuilder {

	enum Endpoint {
		case timetable(TimetableItem, String)
		case item(TimetableItem)
	}

	static func make(endpoint: Endpoint) throws -> NetworkRequest {
		var components: URLComponents = .init()
		components.host = "cist.nure.ua"
		switch endpoint {
		case .timetable(let type, let identifier):
			components.path = "/ias/app/tt/P_API_EVENT_JSON"
			components.queryItems = [
				URLQueryItem(name: "timetable_id", value: identifier),
				URLQueryItem(name: "type_id", value: "\(type.rawValue)"),
				URLQueryItem(name: "idClient", value: apiAccessKey)
			]

		case .item(let type) where type == .group:
			components.path = "/ias/app/tt/P_API_GROUP_JSON"

		case .item(let type) where type == .teacher:
			components.path = "/ias/app/tt/P_API_PODR_JSON"

		case .item(let type) where type == .auditory:
			components.path = "/ias/app/tt/P_API_AUDITORIES_JSON"

		case .item:
			break
		}

		guard let url = components.url else {
			throw KNURERequestBuilder.Error.requestBuild(components.description)
		}

		return NetworkRequest(url: url)
	}

	enum Error: LocalizedError {
		case requestBuild(String)

		var localizedDescription: String {
			switch self {
			case .requestBuild(let message):
				return "Failed to build url: \(message)"
			}
		}
	}
}
