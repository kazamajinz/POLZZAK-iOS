//
//  RefreshTokenAdapter.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/04.
//

import Foundation

final class RefreshTokenAdapter: RequestAdapter {
    override func adaptTask(for urlRequest: inout URLRequest) async {
        if let accessToken = Keychain().read(identifier: Constants.KeychainKey.accessToken),
           let refreshToken = Keychain().read(identifier: Constants.KeychainKey.refreshToken) {
            urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            urlRequest.addValue("RefreshToken=\(refreshToken)", forHTTPHeaderField: "Cookie")
        }
    }
}
