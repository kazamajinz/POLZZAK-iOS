//
//  LoginTarget.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/05.
//

import Foundation

enum LoginTarget {
    case kakao(oAuthAccessToken: String)
    case apple(oAuthAccessToken: String)
}

extension LoginTarget: BasicTargetType {
    var baseURL: String {
        return Constants.URL.baseURL
    }
    
    var path: String {
        switch self {
        case .kakao:
            return "v1/auth/login/kakao"
        case .apple:
            return "v1/auth/login/apple"
        }
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var queryParameters: Encodable? {
        return nil
    }
    
    var sampleData: Data? {
        return nil
    }
    
    var bodyParameters: Encodable? {
        switch self {
        case .kakao(let oAuthAccessToken):
            return ["oAuthAccessToken": oAuthAccessToken]
        case .apple(let oAuthAccessToken):
            return ["oAuthAccessToken": oAuthAccessToken]
        }
    }
}
