//
//  Data+EncodingTransformation.swift
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 10/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

import Foundation

public extension Data {
    public func transform(from encodingSource: String.Encoding,
                          to encodingResult: String.Encoding) -> Data? {
        var tempData = String(data: self, encoding: encodingSource)
        var responseData: Data? = tempData?.data(using: encodingResult)
        let range = NSRange(location: 0, length: (responseData?.count ?? 0) - 1)
        return responseData?.subdata(in: range)
    }
}
