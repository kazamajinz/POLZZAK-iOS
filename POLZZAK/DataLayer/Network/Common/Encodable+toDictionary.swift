//
//  Encodable+toDictionary.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/29.
//

import Foundation

extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        return jsonData as? [String: Any]
    }
}
