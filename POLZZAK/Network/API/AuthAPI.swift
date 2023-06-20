//
//  AuthAPI.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/10.
//

import AuthenticationServices
import Foundation
import UIKit

enum AuthAPIError: LocalizedError {
    case appleLoginNoIdentityToken
    
    var errorDescription: String? {
        switch self {
        case .appleLoginNoIdentityToken: return "애플 로그인 오류; identityToken을 가져올 수 없습니다."
        }
    }
}

struct AuthAPI {
    typealias APIReturnType = (Data, URLResponse)
    
    static func kakaoLogin() async throws -> APIReturnType {
        do {
            let oAuthAccessToken = try await KakaoLoginManager.loginWithKakao()
            let target = LoginTarget.kakao(oAuthAccessToken: oAuthAccessToken)
            let result = try await NetworkService().request(with: target)
            return result
        } catch {
            os_log(log: .userAPI, errorDescription: String(describing: error))
            throw error
        }
    }
    
    static func appleLogin(appleLoginPresentationAnchorView viewController: UIViewController) async throws -> APIReturnType {
        do {
            let appleLoginManager = AppleLoginManager()
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            appleLoginManager.setAppleLoginPresentationAnchorView(viewController)
            
            let authorization = try await appleLoginManager.login(authorizationRequests: [request])
            if case let appleIDCredential as ASAuthorizationAppleIDCredential = authorization.credential,
               let identityToken = appleIDCredential.identityToken,
               let identityTokenString = String(data: identityToken, encoding: .utf8) {
                let target = LoginTarget.kakao(oAuthAccessToken: identityTokenString)
                let result = try await NetworkService().request(with: target)
                return result
            } else {
                throw AuthAPIError.appleLoginNoIdentityToken
            }
        } catch {
            os_log(log: .userAPI, errorDescription: String(describing: error))
            throw error
        }
    }
    
    static func register(
        username: String,
        socialType: String,
        memberType: Int,
        nickname: String
    ) async throws -> APIReturnType {
        do {
            let target = RegisterTarget.register(username: username, socialType: socialType, memberType: memberType, nickname: nickname)
            let result = try await NetworkService().request(with: target)
            return result
        } catch {
            os_log(log: .userAPI, errorDescription: String(describing: error))
            throw error
        }
    }
    
    static func registerWithImage(
        username: String,
        socialType: String,
        memberType: Int,
        nickname: String,
        image: UIImage,
        mimeType: String
    ) async throws -> APIReturnType {
        do {
            let target = RegisterTarget.registerWithImage(username: username, socialType: socialType, memberType: memberType, nickname: nickname, image: image, mimeType: mimeType)
            let result = try await NetworkService().request(with: target)
            return result
        } catch {
            os_log(log: .userAPI, errorDescription: String(describing: error))
            throw error
        }
    }
}
