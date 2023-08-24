//
//  UserInfoTarget.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/14.
//

import Foundation

enum UserInfoTarget {
    /// 해당 Target은 UserInfo를 얻어오는역할과 Token을 refresh하는 역할을 같이 수행하고 있음
    /// - AccessToken이 유효하면 UserInfo를 가져옴
    /// - AccessToken이 유효한데 만료가 되었으면 token refresh를 수행
    /// - AccessToken이 유효하지 않으면 401 Unauthorized 에러를 냄
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
        var headers = ["Content-Type": "application/json"]
        if let accessToken = UserInfoManager.readToken(type: .access),
           let refreshToken = UserInfoManager.readToken(type: .refresh) {
            headers.updateValue("Bearer \(accessToken)", forKey: "Authorization")
            headers.updateValue("RefreshToken=\(refreshToken)", forKey: "Cookie")
        }
        return headers
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
