//
//  KakaoLogin.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/09.
//

import Foundation

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

struct KakaoLoginAPI {
    /// - Returns: accessToken
    static func loginWithKakao() async throws -> String {
        let oAuthToken: OAuthToken
        if UserApi.isKakaoTalkLoginAvailable() {
            oAuthToken = try await UserApi.shared.loginWithKakaoTalk()
        } else {
            oAuthToken = try await UserApi.shared.loginWithKakaoAccount()
        }
        return oAuthToken.accessToken
    }
    
//    static func getKakaoAccessToken() async throws -> String {
//        var accessToken: String?
//        if AuthApi.hasToken() {
//            do {
//                let accessTokenInfo = try await UserApi.shared.accessTokenInfo()
//
//            } catch {
//                if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true {
//                    let oAuthToken = try await loginWithKakao()
//                    accessToken = oAuthToken.accessToken
//                }
//            }
//            UserApi.shared.accessTokenInfo { (_, error) in
//                if let error = error {
//                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
//                        //로그인 필요
//                    }
//                    else {
//                        //기타 에러
//                    }
//                }
//                else {
//                    //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
//                }
//            }
//        } else {
//            //로그인 필요
//        }
//    }
}
