//
//  StampBoardDetailTarget.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/09/14.
//

import Foundation

enum StampBoardDetailTarget {
    case get(stampBoardID: Int)
}

extension StampBoardDetailTarget: BasicTargetType {
    var baseURL: String {
        return Constants.URL.baseURL
    }
    
    var path: String {
        switch self {
        case .get(let stampBoardID):
            return "v1/stamps/stamp-boards/\(stampBoardID)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .get:
            return .get
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json; charset=UTF-8"]
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
