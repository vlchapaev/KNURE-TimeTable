//
//  Data+EncodingTransformation.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 10/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import Foundation

public extension Data {
	func transform(from encodingSource: String.Encoding,
				   to encodingResult: String.Encoding) throws -> Data {

		guard let tempData = String(data: self, encoding: encodingSource) else {
			throw FailedToReadSourceData()
		}

		guard var responseData = tempData.data(using: encodingResult) else {
			throw FailedToTransfromResultData()
		}

		let range = Range<Data.Index>(0...responseData.count - 1)
		return responseData.subdata(in: range)
    }
}

class FailedToReadSourceData: Error {}
class FailedToTransfromResultData: Error {}
