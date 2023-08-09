//
//  LoginViewModel.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/07.
//

import Combine
import Foundation
import UIKit

final class LoginViewModel {
    struct Input {
        let kakaoLogin: AnyPublisher<Void, Never>
        let appleLogin: AnyPublisher<Void, Never>
    }
    
    enum State {
        case showMainScreen
        case showRegisterScreen
        case none
    }
    
    typealias Output = AnyPublisher<State, Never>
    
    func transform(_ input: Input) -> Output {
        let login = loginChains(input)
        return Publishers
            .MergeMany(login)
            .eraseToAnyPublisher()
    }
}

extension LoginViewModel {
    private func loginChains(_ input: Input) -> Output {
        let kakaoLogin = input.kakaoLogin.asyncMap { _ -> (Data, URLResponse)? in
            return try? await AuthAPI.kakaoLogin()
        }
        
        let appleLogin = input.appleLogin.asyncMap { _ -> (Data, URLResponse)? in
            let topVC = DispatchQueue.main.sync {
                UIApplication.getTopViewController()
            }
            guard let topVC else { return nil }
            return try? await AuthAPI.appleLogin(appleLoginPresentationAnchorView: topVC)
        }
        
        return Publishers
            .MergeMany(kakaoLogin, appleLogin)
            .map { result -> State in
                guard let (data, response) = result else { return .none }
                guard let httpResponse = response as? HTTPURLResponse else { return .none }
                let statusCode = httpResponse.statusCode
                
                switch statusCode {
                case 200..<300: // 로그인 성공
                    let dto = try? JSONDecoder().decode(BaseResponseDTO<AccessTokenDTO>.self, from: data)
                    guard let accessToken = dto?.data?.accessToken else { return .none }
                    print("✅ login success!")
                    print("🪙 accessToken: ", accessToken)
                    Keychain().create(identifier: Constants.KeychainKey.accessToken, value: accessToken)
                    if let refreshToken = httpResponse.getRefreshTokenFromCookie() {
                        print("🪙 refreshToken: ", refreshToken)
                        Keychain().create(identifier: Constants.KeychainKey.refreshToken, value: refreshToken)
                    }
                    return .showMainScreen
                case 400: // 회원가입 필요
                    let dto = try? JSONDecoder().decode(BaseResponseDTO<NeedRegisterDTO>.self, from: data)
                    guard let needRegisterDTO = dto?.data else { return .none }
                    print("⚠️ need register")
                    print("username: ", needRegisterDTO.username)
                    print("socialType: ", needRegisterDTO.socialType)
                    Keychain().create(identifier: Constants.KeychainKey.registerUsername, value: needRegisterDTO.username)
                    Keychain().create(identifier: Constants.KeychainKey.registerSocialType, value: needRegisterDTO.socialType)
                    return .showRegisterScreen
                case 401: // 소셜 로그인 실패
                    let dto = try? JSONDecoder().decode(BaseResponseDTO<String>.self, from: data)
                    guard let messages = dto?.messages else { return .none }
                    print(messages)
                    return .none
                default:
                    print("statusCode: ", statusCode)
                    let dto = try? JSONDecoder().decode(BaseResponseDTO<String>.self, from: data)
                    guard let messages = dto?.messages else { return .none }
                    print(messages)
                    return .none
                }
            }
            .eraseToAnyPublisher()
    }
}
