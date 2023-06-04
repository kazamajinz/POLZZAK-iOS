//
//  AuthAdapter.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/04.
//

import Foundation

final class AuthAdapter: RequestAdapter {
    func adapt(for urlRequest: inout URLRequest) {
        print("adapt")
        let accessToken = ""
        let refreshToken = ""
        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("RefreshToken=\(refreshToken)", forHTTPHeaderField: "Cookie")
        urlRequest.httpShouldHandleCookies = true
    }
}
