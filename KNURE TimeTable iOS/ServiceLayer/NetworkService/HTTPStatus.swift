//
//  HTTPStatus.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 30/03/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import Foundation

public enum HTTPStatus: CustomStringConvertible {
	case info(subType: HTTPInfo)
	case success(subType: HTTPSuccess)
	case redirection(subType: HTTPRedirection)
	case clientError(subType: HTTPClientError)
	case serverError(subType: HTTPServerError)
	case undefined

	// swiftlint:disable:next cyclomatic_complexity
	public init(code: Int) {
		switch code {
		case 100 ..< 200:
			guard let subtype = HTTPInfo(rawValue: code) else { self = .undefined; return }
			self = .info(subType: subtype)

		case 200 ..< 300:
			guard let subtype = HTTPSuccess(rawValue: code) else { self = .undefined; return }
			self = .success(subType: subtype)

		case 300 ..< 400:
			guard let subtype = HTTPRedirection(rawValue: code) else { self = .undefined; return }
			self = .redirection(subType: subtype)

		case 400 ..< 500:
			guard let subtype = HTTPClientError(rawValue: code) else { self = .undefined; return }
			self = .clientError(subType: subtype)

		case 500 ..< 600:
			guard let subtype = HTTPServerError(rawValue: code) else { self = .undefined; return }
			self = .serverError(subType: subtype)

		default:
			self = .undefined
		}
	}

	public var description: String {
		switch self {
		case .info(let subType):
			return "Info: \(subType.description)"

		case .success(let subType):
			return "Success: \(subType.description)"

		case .redirection (let subType):
			return "Redirection: \(subType.description)"

		case .clientError (let subType):
			return "Client error: \(subType.description)"

		case .serverError (let subType):
			return "Server error: \(subType.description)"

		case .undefined:
			return "Unknown HTTP Status"
		}
	}
}

public enum HTTPInfo: Int, CustomStringConvertible {
	case `continue` 		= 100
	case switchingProtocols = 101
	case processing 		= 102

	public var description: String {
		switch self {
		case .continue:
			return "Continue"

		case .switchingProtocols:
			return "Switching protocols"

		case .processing:
			return "Processing"
		}
	}
}

public enum HTTPSuccess: Int {
	// swiftlint:disable:next identifier_name
	case ok 						 = 200
	case created					 = 201
	case accepted  					 = 202
	case nonAuthoritativeInformation = 203
	case noContent 					 = 204
	case resetContent                = 205
	case partialContent              = 206
	case multiStatus                 = 207
	case alreadyReported             = 208
	case imUsed                      = 226

	public var description: String {
		switch self {
		case .ok:
			return "OK"

		case .created:
			return "Created"

		case .accepted:
			return "Accepted"

		case .nonAuthoritativeInformation:
			return "Non authoritative information"

		case .noContent:
			return "No content"

		case .resetContent:
			return "Reset content"

		case .partialContent:
			return "Partial content"

		case .multiStatus:
			return "Multi status"

		case .alreadyReported:
			return "Already reported"

		case .imUsed:
			return "IM used"
		}
	}
}

public enum HTTPRedirection: Int, CustomStringConvertible {
	case multipleChoices   = 300
	case movedPermanently  = 301
	case found             = 302
	case seeOther          = 303
	case notModified       = 304
	case useProxy          = 305
	case switchProxy       = 306
	case temporaryRedirect = 307
	case permanentRedirect = 308

	public var description: String {
		switch self {
		case .multipleChoices:
			return "Multiple choices"

		case .movedPermanently:
			return "Moved permanently"

		case .found:
			return "Found"

		case .seeOther:
			return "See other"

		case .notModified:
			return "Not modified"

		case .useProxy:
			return "Use proxy"

		case .switchProxy:
			return "Switch proxy"

		case .temporaryRedirect:
			return "Temporary redirect"

		case .permanentRedirect:
			return "Permanent redirect"
		}
	}
}

public enum HTTPClientError: Int, CustomStringConvertible {
	case badRequest                  = 400
	case unauthorized                = 401
	case paymentRequired             = 402
	case forbidden                   = 403
	case notFound                    = 404
	case methodNotAllowed            = 405
	case notAcceptable               = 406
	case proxyAuthenticationRequired = 407
	case requestTimeout              = 408
	case conflict                    = 409
	case gone                        = 410
	case lengthRequired              = 411
	case preconditionFailed          = 412
	case payloadTooLarge             = 413
	case uriTooLong                  = 414
	case unsupportedMediaType        = 415
	case rangeNotSatifiable          = 416
	case imATeapot                   = 418
	case misdirectRequested          = 421
	case unprocessedEntity           = 422
	case locked                      = 423
	case failedDependency            = 424
	case upgradeRequired             = 426
	case preconditionRequired        = 428
	case tooManyRequests             = 429
	case requestHeaderFieldsTooLarge = 431
	case unavailableForLegalReasons  = 451

	public var description: String {
		switch self {
		case .badRequest:
			return "Bad request"

		case .unauthorized:
			return "Unauthorized"

		case .paymentRequired:
			return "Payment required"

		case .forbidden:
			return "Forbidden"

		case .notFound:
			return "NotFound"

		case .methodNotAllowed:
			return "Method not allowed"

		case .notAcceptable:
			return "Not acceptable"

		case .proxyAuthenticationRequired:
			return "Proxy authentication required"

		case .requestTimeout:
			return "Request timeout"

		case .conflict:
			return "Conflict"

		case .gone:
			return "Gone"

		case .lengthRequired:
			return "Length required"

		case .preconditionFailed:
			return "Precondition failed"

		case .payloadTooLarge:
			return "Payload too large"

		case .uriTooLong:
			return "URI too long"

		case .unsupportedMediaType:
			return "Unsupported media type"

		case .rangeNotSatifiable:
			return "Range not datifiable"

		case .imATeapot:
			return "I'm a teapot"

		case .misdirectRequested:
			return "Misdirect requested"

		case .unprocessedEntity:
			return "Unprocessed entity"

		case .locked:
			return "Locked"

		case .failedDependency:
			return "Failed dependency"

		case .upgradeRequired:
			return "Upgrade required"

		case .preconditionRequired:
			return "Precondition required"

		case .tooManyRequests:
			return "Too many requests"

		case .requestHeaderFieldsTooLarge:
			return "Request header fields too large"

		case .unavailableForLegalReasons:
			return "Unavailable for legal reasons"
		}
	}
}

public enum HTTPServerError: Int, CustomStringConvertible {
	case internalServerError           = 500
	case notImplemented                = 501
	case badGateway                    = 502
	case serviceUnavailable            = 503
	case gatewayTimeout                = 504
	case httpVersionNotSupported       = 505
	case variantAlsoNegotiates         = 506
	case insufficientStorage           = 507
	case loopDetected                  = 508
	case notExtended                   = 510
	case networkAuthenticationRequired = 511

	public var description: String {
		switch self {
		case .internalServerError:
			return "Internal server error"

		case .notImplemented:
			return "Not implemented"

		case .badGateway:
			return "Bad gateway"

		case .serviceUnavailable:
			return "Service unavailable"

		case .gatewayTimeout:
			return "Gateway timeout"

		case .httpVersionNotSupported:
			return "HTTPVersion not supported"

		case .variantAlsoNegotiates:
			return "Variant also negotiates"

		case .insufficientStorage:
			return "Insufficient storage"

		case .loopDetected:
			return "Loop detected"

		case .notExtended:
			return "Not extended"

		case .networkAuthenticationRequired:
			return "Network authentication required"
		}
	}
}
