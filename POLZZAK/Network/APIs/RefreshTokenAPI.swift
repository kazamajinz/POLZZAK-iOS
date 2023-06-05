//
//  RefreshTokenAPI.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/05.
//

import Foundation

struct RefreshTokenAPI {
    private let networkService = NetworkService(requestAdapter: RefreshTokenAdapter())
    
    func refreshToken() async throws -> TokenResponseDTO {
        let endPoint = Endpoint<TokenResponseDTO>(baseURL: Constants.URL.baseURL, path: "v1/users/me", method: .get)
        return try await networkService.request(with: endPoint)
    }
}
