//
//  MemberTypeTarget.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/27.
//

import Foundation

enum MemberTypeTarget {
    case memberTypes
}

extension MemberTypeTarget: BasicTargetType {
    var baseURL: String {
        return Constants.URL.baseURL
    }
    
    var path: String {
        return "v1/member-types"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var queryParameters: Encodable? {
        return nil
    }
    
    var bodyParameters: Encodable? {
        return nil
    }
    
    var sampleData: Data? {
        return nil
    }
}
