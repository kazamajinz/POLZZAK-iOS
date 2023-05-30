//
//  RequestAdapter.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/30.
//

import Foundation

protocol RequestAdapter {
    func adapt(for urlRequest: inout URLRequest)
}

class AuthAdapter: RequestAdapter {
    func adapt(for urlRequest: inout URLRequest) {
        print("adapt")
        let accessToken = ""
        let refreshToken = ""
        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("RefreshToken=\(refreshToken)", forHTTPHeaderField: "Cookie")
        urlRequest.httpShouldHandleCookies = true
    }
}
