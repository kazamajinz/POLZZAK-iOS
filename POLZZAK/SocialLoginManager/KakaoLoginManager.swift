//
//  KakaoLoginManager.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/09.
//

import Foundation

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

class KakaoLoginManager {
    /// - Returns: accessToken; 폴짝API에서 oAuthAccessToken으로 쓰이게 됨
    static func loginWithKakao() async throws -> String {
        let oAuthToken: OAuthToken
        if UserApi.isKakaoTalkLoginAvailable() {
            oAuthToken = try await UserApi.shared.loginWithKakaoTalk()
        } else {
            oAuthToken = try await UserApi.shared.loginWithKakaoAccount()
        }
        return oAuthToken.accessToken
    }
}
