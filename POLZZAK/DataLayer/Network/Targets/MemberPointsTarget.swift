//
//  MemberPointsTarget.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/18.
//

import Foundation

enum MemberPointsTarget {
    case getInfo
}

extension MemberPointsTarget: BasicTargetType {
    var baseURL: String {
        return Constants.URL.baseURL
    }
    
    var path: String {
        return "v1/member-points/me"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var queryParameters: Encodable? {
        nil
    }
    
    var sampleData: Data? {
        nil
    }
    
    var bodyParameters: Encodable? {
        nil
    }
}
