//
//  AuthAdapter.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/04.
//

import Foundation

final class AuthAdapter: RequestAdapter {
    override func adaptTask(for urlRequest: inout URLRequest) async {
        if let accessToken = Keychain().read(identifier: Constants.KeychainKey.accessToken) {
            urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
    }
}
