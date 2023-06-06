//
//  UserApi+extension.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/06.
//

import KakaoSDKAuth
import KakaoSDKUser

extension UserApi {
    func loginWithKakaoTalk() async throws -> OAuthToken {
        return try await withCheckedThrowingContinuation { continuation in
            loginWithKakaoTalk { oauthToken, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    // 강제 언래핑 하면 안될듯
                    continuation.resume(returning: oauthToken!)
                }
            }
        }
    }
}
