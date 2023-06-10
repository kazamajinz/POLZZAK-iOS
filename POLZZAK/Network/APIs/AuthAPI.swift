//
//  AuthAPI.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/04.
//

import Foundation

enum AuthAPI {
    case authorize
}

extension AuthAPI: APIType {
    var baseURL: String {
        return Constants.URL.baseURL
    }
    
    var path: String {
        switch self {
        case .authorize:
            return "v1/users/me"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .authorize:
            return .get
        }
    }
    
    var queryParameters: Encodable? {
        switch self {
        case .authorize:
            return nil
        }
    }
    
    var bodyParameters: Encodable? {
        switch self {
        case .authorize:
            return nil
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .authorize:
            return nil
        }
    }
    
    var intercetpr: RequestInterceptor? {
        switch self {
        case .authorize:
            return AuthInterceptor()
        }
    }
    
    var sampleData: Data? {
        return nil
    }
}
