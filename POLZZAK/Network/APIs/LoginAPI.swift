//
//  LoginAPI.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/05.
//

import Foundation

enum SocialProvider: String {
    case kakao
    case apple
}

struct LoginAPI {
    private let networkService = NetworkService()
    private let socialProvider: SocialProvider
    
    func login(socialProviderToken accessToken: String) async throws -> LoginResponseDTO {
        let endpoint = Endpoint<LoginResponseDTO>(
            baseURL: Constants.URL.baseURL,
            path: "v1/auth/login/\(socialProvider.rawValue)",
            method: .post,
            bodyParameters: ["oAuthAccessToken": accessToken],
            headers: ["Content-Type": "application/json"]
        )
        return try await networkService.request(with: endpoint)
    }
}
