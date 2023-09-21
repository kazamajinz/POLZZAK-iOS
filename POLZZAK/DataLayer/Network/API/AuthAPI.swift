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
    
    // MARK: - 1. 로그인 API
    
    static func kakaoLogin() async throws -> APIReturnType {
        do {
            let oAuthAccessToken = try await KakaoLoginManager.loginWithKakao()
            let target = LoginTarget.kakao(oAuthAccessToken: oAuthAccessToken)
            //TODO: - 임시 변경
            let result = try await NetworkService().request(with: target)
            return result
        } catch {
            os_log(log: .polzzakAPI, errorDescription: String(describing: error))
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
                // TODO: identityToken을 서버에 보내야 하는지는 아직 정해지지 않았음. 수정 필요.
                let target = LoginTarget.apple(oAuthAccessToken: identityTokenString)
                //TODO: - 임시 변경
                let result = try await NetworkService().request(with: target)
                return result
            } else {
                throw AuthAPIError.appleLoginNoIdentityToken
            }
        } catch {
            os_log(log: .polzzakAPI, errorDescription: String(describing: error))
            throw error
        }
    }
    
    // MARK: - 2. 회원가입 API
    static func register(
        username: String,
        socialType: String,
        memberType: Int,
        nickname: String,
        image: UIImage?
    ) async throws -> APIReturnType {
        do {
            let target: RegisterTarget
            if let image {
                target = RegisterTarget.registerWithImage(username: username, socialType: socialType, memberType: memberType, nickname: nickname, image: image)
            } else {
                target = RegisterTarget.register(username: username, socialType: socialType, memberType: memberType, nickname: nickname)
            }
            //TODO: - 임시 변경
            let result = try await NetworkService().request(with: target)
            return result
        } catch {
            os_log(log: .polzzakAPI, errorDescription: String(describing: error))
            throw error
        }
    }
    
    // MARK: - 3. 닉네임 중복 확인 API
    
    static func checkNicknameDuplicate(nickname: String) async throws -> APIReturnType {
        do {
            let target = NicknameTarget.checkDuplicate(nickname: nickname)
            //TODO: - 임시 변경
            let result = try await NetworkService().request(with: target)
            return result
        } catch {
            os_log(log: .polzzakAPI, errorDescription: String(describing: error))
            throw error
        }
    }
}
