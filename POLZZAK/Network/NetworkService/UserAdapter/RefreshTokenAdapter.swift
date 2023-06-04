//
//  RefreshTokenAdapter.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/04.
//

import Foundation

final class RefreshTokenAdapter: RequestAdapter {
    override func adaptTask(for urlRequest: inout URLRequest) {
        // TODO: UserDefaults로 수정
        let accessToken = ""
        let refreshToken = ""
        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("RefreshToken=\(refreshToken)", forHTTPHeaderField: "Cookie")
    }
}
