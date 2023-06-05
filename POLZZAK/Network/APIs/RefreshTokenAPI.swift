//
//  RefreshTokenAPI.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/05.
//

import Foundation

struct RefreshTokenAPI {
    private let networkService: NetworkServiceProvider = NetworkService(requestAdapter: RefreshTokenAdapter())
    
    func refreshToken() async throws -> TokenResponseDTO {
        let endPoint = Endpoint<TokenResponseDTO>(baseURL: "https://api.polzzak.co.kr/", path: "api/v1/users/me", method: .get)
        return try await networkService.request(with: endPoint)
    }
}
