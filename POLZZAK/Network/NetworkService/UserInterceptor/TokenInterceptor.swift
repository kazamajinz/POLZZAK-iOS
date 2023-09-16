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
        
        if let accessToken = UserInfoManager.readToken(type: .access) {
            urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        return urlRequest
    }
    
    func retry(response: URLResponse) async throws -> RetryResult {
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 else {
            return .doNotRetry
        }
        
        do {
            let target = UserInfoTarget.getUserInfo
            let networkService = NetworkService()
            
            let (data, response) = try await networkService.request(with: target)
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(BaseResponseDTO<String>.self, from: data)
            
            if decodedData.code == 434, let accessToken = decodedData.data,
               let httpResponse = response as? HTTPURLResponse,
               let refreshToken = httpResponse.getRefreshTokenFromCookie() {
                print("TokenInterceptor -")
                print("🥬🪙 refreshed accessToken: ", accessToken)
                print("🥬🪙 refreshed refreshToken: ", refreshToken)
                UserInfoManager.saveToken(accessToken, type: .access)
                UserInfoManager.saveToken(refreshToken, type: .refresh)
                return .retry
            } else {
                let httpResponse = response as? HTTPURLResponse
                let cookie = httpResponse?.allHeaderFields["Set-Cookie"] as? String
                // TODO: - 아래 프린트문 삭제(다른 프린트문들은 log로?)
                print("cookie: ", cookie ?? "")
                print("refresh token: ", httpResponse?.getRefreshTokenFromCookie() ?? "")
                print("refreshed fail - \(String(describing: decodedData.messages))")
                print("- code \(decodedData.code)")
                return .doNotRetry
            }
        } catch {
            return .doNotRetryWithError(error)
        }
    }
}
