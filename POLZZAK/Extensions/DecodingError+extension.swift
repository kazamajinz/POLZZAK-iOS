//
//  DecodingError+extension.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/31.
//

import Foundation

extension DecodingError {
    var description: String {
            switch self {
            case .keyNotFound(let key, _):
                return "Decoding Error: Key '\(key.stringValue)' not found."
            case .valueNotFound(let type, _):
                return "Decoding Error: Value '\(type)' not found."
            case .typeMismatch(let type, _):
                return "Decoding Error: Type '\(type)' mismatch."
            case .dataCorrupted(let context):
                return "Decoding Error: \(context.debugDescription)"
            @unknown default:
                return "Decoding Error: Unknown error."
            }
        }
}
