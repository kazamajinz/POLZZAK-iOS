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
            // TODO: UserDefaults같은 싱글톤에 새로 받은 accessToken 추가하도록 수정
            return .retry
        } catch {
            os_log("%@", log: .network, String(describing: error))
            return .doNotRetryWithError(error)
        }
    }
}
