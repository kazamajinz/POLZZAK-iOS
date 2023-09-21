//
//  LoginViewModel.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/07.
//

import Combine
import Foundation
import UIKit

// TODO: Input, Output 말고 Action, State, (Mutate) 로 바꿔보기??
// ???: 그러면 여기서는 뭐가 State가 되어야 하지?

final class LoginViewModel {
    enum Input {
        case kakaoLogin
        case appleLogin
    }
    
    enum Output {
        case showMainScreen
        case showRegisterScreen
    }
    
    private var cancellables = Set<AnyCancellable>()
    let input = PassthroughSubject<Input, Never>()
    let output = PassthroughSubject<Output, Never>()
    
    init() {
        bind()
    }
}

extension LoginViewModel {
    private func bind() {
        input.sink { [weak self] input in
            Task { [weak self] in
                let loginResult: (Data, URLResponse)?
                switch input {
                case .kakaoLogin:
                    loginResult = try? await AuthAPI.kakaoLogin()
                case .appleLogin:
                    let topVC = await UIApplication.getTopViewController()
                    guard let topVC else { return }
                    loginResult = try? await AuthAPI.appleLogin(appleLoginPresentationAnchorView: topVC)
                }
                self?.handleLoginResult(result: loginResult)
            }
        }
        .store(in: &cancellables)
    }
    
    private func handleLoginResult(result: (Data, URLResponse)?) {
        guard let (data, response) = result else { return }
        guard let httpResponse = response as? HTTPURLResponse else { return }
        let statusCode = httpResponse.statusCode
        
        switch statusCode {
        case 200..<300: // 로그인 성공
            let dto = try? JSONDecoder().decode(BaseResponseDTO<AccessTokenDTO>.self, from: data)
            guard let accessToken = dto?.data?.accessToken else { return }
            print("✅ login success!")
            print("🪙 accessToken: ", accessToken)
            UserInfoManager.saveToken(accessToken, type: .access)
            if let refreshToken = httpResponse.getRefreshTokenFromCookie() {
                print("🪙 refreshToken: ", refreshToken)
                UserInfoManager.saveToken(refreshToken, type: .refresh)
            }
            output.send(.showMainScreen)
        case 400: // 회원가입 필요
            let dto = try? JSONDecoder().decode(BaseResponseDTO<NeedRegisterDTO>.self, from: data)
            guard let needRegisterDTO = dto?.data else { return }
            print("⚠️ need register")
            print("username: ", needRegisterDTO.username)
            print("socialType: ", needRegisterDTO.socialType)
            UserInfoManager.saveRegisterInfo(username: needRegisterDTO.username, socialType: needRegisterDTO.socialType)
            output.send(.showRegisterScreen)
        case 401: // 소셜 로그인 실패
            let dto = try? JSONDecoder().decode(BaseResponseDTO<String>.self, from: data)
            guard let messages = dto?.messages else { return }
            print(messages)
        default:
            print("statusCode: ", statusCode)
            let dto = try? JSONDecoder().decode(BaseResponseDTO<String>.self, from: data)
            guard let messages = dto?.messages else { return }
            print(messages)
        }
    }
}
