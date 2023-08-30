//
//  Data+prettyJSON.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/28.
//

import Foundation

extension Data {
    var prettyJSON: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedJSON = String(data: data, encoding:.utf8)
        else { return nil }
        return prettyPrintedJSON
    }
}
