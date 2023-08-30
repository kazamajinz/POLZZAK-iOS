//
//  NicknameTarget.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/26.
//

import Foundation

enum NicknameTarget {
    case checkDuplicate(nickname: String)
}

extension NicknameTarget: BasicTargetType {
    var baseURL: String {
        return Constants.URL.baseURL
    }
    
    var path: String {
        return "v1/auth/validate/nickname"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var queryParameters: Encodable? {
        var query = [String: String]()
        switch self {
        case .checkDuplicate(let nickname):
            query["value"] = nickname
            return query
        }
    }
    
    var bodyParameters: Encodable? {
        return nil
    }
    
    var sampleData: Data? {
        return nil
    }
}
