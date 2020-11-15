//
//  IgnoreFailable.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 11/10/2020.
//  Copyright © 2020 Vladislav Chapaev. All rights reserved.
//

@propertyWrapper
struct IgnoreFailable<T: Decodable>: Decodable {

	private struct Dummy: Decodable { }

    var wrappedValue: [T] = []

	init(from decoder: Decoder) throws {
		guard var container = try? decoder.unkeyedContainer() else { return }
		while !container.isAtEnd {
			if let decoded = try? container.decode(T.self) {
				wrappedValue.append(decoded)
			} else {
				_ = try? container.decode(Dummy.self)
			}
		}
	}
}

struct Throwable<T: Decodable>: Decodable {
    let result: Result<T, Error>

    init(from decoder: Decoder) throws {
        result = Result(catching: { try T(from: decoder) })
    }
}
