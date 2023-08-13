//
//  UserInfoTarget.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/14.
//

import Foundation

enum UserInfoTarget {
    case getUserInfo
}

extension UserInfoTarget: BasicTargetType {
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
        return ["Content-Type": "application/json"]
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
