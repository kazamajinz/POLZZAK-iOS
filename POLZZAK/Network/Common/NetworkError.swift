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
    case doNotRetryButEmptyDataOrResponse
    
    var errorDescription: String? {
        switch self {
        case .unknownError: return "알수 없는 에러입니다."
        case .invalidHTTPStatusCode: return "status코드가 200~299가 아닙니다."
        case .components: return "components 관련 에러가 발생했습니다."
        case .doNotRetryButEmptyDataOrResponse: return "사용자가 doNotRetry를 설정했으나 data 또는 response가 비었습니다."
        }
    }
}
