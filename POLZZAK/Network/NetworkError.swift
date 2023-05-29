//
//  NetworkError.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/29.
//

import Foundation

enum NetworkError: LocalizedError {
    case unknownError
    case invalidHTTPStatusCode(Int)
    case components

    var errorDescription: String? {
        switch self {
        case .unknownError: return "알수 없는 에러입니다."
        case .invalidHTTPStatusCode: return "status코드가 200~299가 아닙니다."
        case .components: return "components 관련 에러가 발생했습니다."
        }
    }
}
