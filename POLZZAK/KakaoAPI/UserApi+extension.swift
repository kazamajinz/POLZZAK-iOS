//
//  UserApi+extension.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/06.
//

import Foundation

import KakaoSDKAuth
import KakaoSDKUser

typealias KakaoUserAPI = UserApi

enum KakaoUserAPIError: LocalizedError {
    case noResponseData
    
    var errorDescription: String? {
        switch self {
        case .noResponseData: return "data와 error 모두 nil입니다."
        }
    }
}

extension UserApi {
    @MainActor
    func loginWithKakaoTalk() async throws -> OAuthToken {
        return try await withCheckedThrowingContinuation { continuation in
            loginWithKakaoTalk { oauthToken, error in
                if let error {
                    continuation.resume(throwing: error)
                } else if let oauthToken {
                    continuation.resume(returning: oauthToken)
                } else {
                    continuation.resume(throwing: KakaoUserAPIError.noResponseData)
                }
            }
        }
    }
    
    @MainActor
    func loginWithKakaoAccount() async throws -> OAuthToken {
        return try await withCheckedThrowingContinuation { continuation in
            loginWithKakaoAccount { oauthToken, error in
                if let error {
                    continuation.resume(throwing: error)
                } else if let oauthToken {
                    continuation.resume(returning: oauthToken)
                } else {
                    continuation.resume(throwing: KakaoUserAPIError.noResponseData)
                }
            }
        }
    }
}
