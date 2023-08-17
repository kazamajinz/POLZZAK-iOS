//
//  TempRegisterViewController.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/09.
//

import Combine
import UIKit

import CombineCocoa
import SnapKit

class TempRegisterViewController: UIViewController {
    enum Constants {
        static let basicInset: CGFloat = 16
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private let nextButton = RegisterNextButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLayout()
        configureBinding()
    }
    
    private func configureView() {
        view.backgroundColor = .gray100
        nextButton.setTitle(text: "회원가입 완료")
    }
    
    private func configureLayout() {
        view.addSubview(nextButton)
        
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constants.basicInset)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.basicInset)
            make.height.equalTo(50)
        }
    }
    
    private func configureBinding() {
        nextButton.tapPublisher
            .sink { _ in
                guard let username = Keychain().read(identifier: POLZZAK.Constants.KeychainKey.registerUsername),
                      let socialType = Keychain().read(identifier: POLZZAK.Constants.KeychainKey.registerSocialType)
                else { return }
                
                Task {
                    let number = Int.random(in: 0...100000)
                    guard let (data, response) = try? await AuthAPI.register(username: username, socialType: socialType, memberType: 1, nickname: "ios\(number)"), let httpResponse = response as? HTTPURLResponse else { return }
                    let statusCode = httpResponse.statusCode
                    
                    switch statusCode {
                    case 200..<300:
                        let dto = try? JSONDecoder().decode(BaseResponseDTO<AccessTokenDTO>.self, from: data)
                        guard let accessToken = dto?.data?.accessToken else { return }
                        print("✅ register success!")
                        print("🪙 accessToken: ", accessToken)
                        Keychain().create(identifier: POLZZAK.Constants.KeychainKey.accessToken, value: accessToken)
                        if let refreshToken = httpResponse.getRefreshTokenFromCookie() {
                            print("🪙 refreshToken: ", refreshToken)
                            Keychain().create(identifier: POLZZAK.Constants.KeychainKey.refreshToken, value: refreshToken)
                        }
                        Keychain().delete(identifier: POLZZAK.Constants.KeychainKey.registerUsername)
                        Keychain().delete(identifier: POLZZAK.Constants.KeychainKey.registerSocialType)
                        AppFlowController.shared.showLoading() // TODO: 이 부분은 폴짝의 세계로! 로딩이 보여야 함
                    case 400:
                        let dto = try? JSONDecoder().decode(BaseResponseDTO<String>.self, from: data)
                        guard let messages = dto?.messages else { return }
                        print("⚠️ failed register")
                        print("messages: ", messages)
                    default:
                        print("statusCode: ", statusCode)
                        let dto = try? JSONDecoder().decode(BaseResponseDTO<String>.self, from: data)
                        guard let messages = dto?.messages else { return }
                        print(messages)
                    }
                }
            }
            .store(in: &cancellables)
    }
}
