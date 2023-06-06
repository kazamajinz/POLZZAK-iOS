//
//  AuthRetrier.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/04.
//

import Foundation
import OSLog

final class AuthRetrier: RequestRetrier {
    override func checkIfRetryIsNeeded(for response: URLResponse) async -> RetryResult {
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 else {
            return .doNotRetry
        }
        
        do {
            let data = try await RefreshTokenAPI().refreshToken()
            if data.code == 434, let accessToken = data.data {
                Keychain().create(identifier: Constants.KeychainKey.accessToken, value: accessToken)
                return .retry
            } else {
                return .doNotRetry
            }
        } catch {
            os_log("%@", log: .network, String(describing: error))
            return .doNotRetryWithError(error)
        }
    }
}
