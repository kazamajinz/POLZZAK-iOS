//
//  AuthAdapter.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/04.
//

import Foundation

final class AuthAdapter: RequestAdapter {
    override func adaptTask(for urlRequest: inout URLRequest) {
        let accessToken = ""
        let refreshToken = ""
        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("RefreshToken=\(refreshToken)", forHTTPHeaderField: "Cookie")
        urlRequest.httpShouldHandleCookies = true
    }
}
