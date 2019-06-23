//
//  HTTPStatus.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 30/03/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import Foundation

enum HTTPStatus: Int, Error {

	enum ResponseType {
		case informational
		case success
		case redirection
		case clientError
		case serverError
		case undefined
	}

	// MARK: - Informational - 1xx

	case `continue` = 100
	case switchingProtocols = 101
	case processing = 102

	// MARK: - Success - 2xx

	case ok = 200 // swiftlint:disable:this identifier_name
	case created = 201
	case accepted = 202
	case nonAuthoritativeInformation = 203
	case noContent = 204

	// MARK: - Redirection - 3xx

	case notModified = 304

	// MARK: - Client Error - 4xx

	case badRequest = 400
	case unauthorized = 401
	case forbidden = 403
	case notFound = 404

	// MARK: - Server Error - 5xx

	case internalServerError = 500
	case notImplemented = 501
	case badGateway = 502
	case serviceUnavailable = 503
	case gatewayTimeout = 504

	case undefined = -1

	var responseType: ResponseType {

		switch self.rawValue {

		case 100..<200:
			return .informational

		case 200..<300:
			return .success

		case 300..<400:
			return .redirection

		case 400..<500:
			return .clientError

		case 500..<600:
			return .serverError

		default:
			return .undefined

		}

	}

	init(code: Int) {
		self = HTTPStatus(rawValue: code) ?? .undefined
	}

}

extension HTTPURLResponse {

	var status: HTTPStatus {
		return HTTPStatus(rawValue: statusCode) ?? .undefined
	}

}
