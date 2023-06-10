//
//  AuthInterceptor.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/10.
//

import Foundation

class AuthInterceptor: RequestInterceptor {
    func adapt(for urlRequest: URLRequest) async throws -> URLRequest {
        var urlRequest = urlRequest
        
        if let accessToken = Keychain().read(identifier: Constants.KeychainKey.accessToken) {
            urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        return urlRequest
    }
    
    func retry(response: URLResponse) async throws -> RetryResult {
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
            return .doNotRetryWithError(error)
        }
    }
}
