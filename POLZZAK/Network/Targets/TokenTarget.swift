//
//  TokenTarget.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/04.
//

import Foundation

enum TokenTarget {
    case checkToken
    case refreshToken
}

extension TokenTarget: BasicTargetType {
    var baseURL: String {
        return Constants.URL.baseURL
    }
    
    var path: String {
        return "v1/users/me"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String : String]? {
        var headers = ["Content-Type": "application/json"]
        switch self {
        case .checkToken:
            return headers
        case .refreshToken:
            // TODO: "RefreshToken=\() 붙이는거 자동으로 가능?"
            if let refreshToken = Keychain().read(identifier: Constants.KeychainKey.refreshToken) {
                headers.updateValue("Cookie", forKey: "RefreshToken=\(refreshToken)")
            }
            return headers
        }
    }
    
    var queryParameters: Encodable? {
        return nil
    }
    
    var sampleData: Data? {
        return nil
    }
    
    var bodyParameters: Encodable? {
        return nil
    }
}
