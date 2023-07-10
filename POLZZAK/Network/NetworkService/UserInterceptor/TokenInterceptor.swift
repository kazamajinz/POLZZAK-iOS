//
//  TokenInterceptor.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/10.
//

import Foundation

class TokenInterceptor: RequestInterceptor {
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
            let api = TokenTarget.refreshToken
            let networkService = NetworkService()
            let (data, response) = try await networkService.request(responseType: BaseResponseDTO<String>.self, with: api)
            
            if data.code == 434, let accessToken = data.data,
               let httpResponse = response as? HTTPURLResponse,
               let refreshToken = (httpResponse.allHeaderFields["Set-Cookie"] as? String)?.getRefreshTokenFromCookie() {
                Keychain().create(identifier: Constants.KeychainKey.accessToken, value: accessToken)
                Keychain().create(identifier: Constants.KeychainKey.refreshToken, value: refreshToken)
                print("🪙 refreshToken: ", refreshToken)
                return .retry
            } else {
                return .doNotRetry
            }
        } catch {
            return .doNotRetryWithError(error)
        }
    }
}