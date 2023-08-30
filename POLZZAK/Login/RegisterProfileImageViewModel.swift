//
//  RegisterProfileImageViewModel.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/28.
//

import Combine
import Foundation

final class RegisterProfileImageViewModel {
    enum Input {
        case register
    }
    
    enum Output {
        case showMain
    }
    
    let registerModel: RegisterModel
    let input = PassthroughSubject<Input, Never>()
    let output = PassthroughSubject<Output, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(registerModel: RegisterModel) {
        self.registerModel = registerModel
        bind()
    }
    
    private func bind() {
        input.sink { [weak self] input in
            guard let self else { return }
            switch input {
            case .register:
                requestRegister()
            }
        }
        .store(in: &cancellables)
    }
    
    private func requestRegister() {
        guard let memberType = registerModel.memberType, let nickname = registerModel.nickname,
              let (username, socialType) = UserInfoManager.readRegisterInfo()
        else { return }
        
        Task { [weak self] in
            guard let self else { return }
            guard let (data, response) = try? await AuthAPI.register(username: username, socialType: socialType, memberType: memberType, nickname: nickname, image: registerModel.profileImage) else { return }
            guard let httpResponse = response as? HTTPURLResponse else { return }
            let statusCode = httpResponse.statusCode
            
            switch statusCode {
            case 200..<300:
                let dto = try? JSONDecoder().decode(BaseResponseDTO<AccessTokenDTO>.self, from: data)
                guard let accessToken = dto?.data?.accessToken else { return }
                print("✅ register success!")
                print("🪙 accessToken: ", accessToken)
                UserInfoManager.saveToken(accessToken, type: .access)
                if let refreshToken = httpResponse.getRefreshTokenFromCookie() {
                    print("🪙 refreshToken: ", refreshToken)
                    UserInfoManager.saveToken(refreshToken, type: .refresh)
                }
                UserInfoManager.deleteRegisterInfo()
                output.send(.showMain)
            case 400:
                print("⚠️ failed register")
            default:
                break
            }
        }
    }
}
