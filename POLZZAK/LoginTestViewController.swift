//
//  LoginTestViewController.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/10.
//

import OSLog
import UIKit

import RxCocoa
import RxSwift
import SnapKit

import KakaoSDKUser

class LoginTestViewController: UIViewController {
    
    private var disposeBag = DisposeBag()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5
        stackView.axis = .vertical
        return stackView
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("카카오 로그인", for: .normal)
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("폴짝 가입", for: .normal)
        return button
    }()
    
    private let unRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("폴짝 탈퇴", for: .normal)
        return button
    }()
    
    private var username: String? = "KAKAO_2845741604"
    private var socialType: String? = "KAKAO"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
        bind()
    }
    
    private func configure() {
        view.addSubview(stackView)
        
        [loginButton, registerButton, unRegisterButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func bind() {
        loginButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                Task {
                    guard let (data, response) = try? await AuthAPI.login(), let httpResponse = response as? HTTPURLResponse else { return }
                    let statusCode = httpResponse.statusCode
                    
                    switch statusCode {
                    case 200..<300:
                        let dto = try? JSONDecoder().decode(BaseResponseDTO<AccessTokenDTO>.self, from: data)
                        guard let accessToken = dto?.data?.accessToken else { return }
                        print("✅ login success!")
                        print("🪙 accessToken: ", accessToken)
                    case 400:
                        let dto = try? JSONDecoder().decode(BaseResponseDTO<NeedRegisterDTO>.self, from: data)
                        guard let needRegisterDTO = dto?.data else { return }
                        print("⚠️ need register")
                        print("username: ", needRegisterDTO.username)
                        print("socialType: ", needRegisterDTO.socialType)
                        owner.username = needRegisterDTO.username
                        owner.socialType = needRegisterDTO.socialType
                    default:
                        return
                    }
                }
            })
            .disposed(by: disposeBag)
        
        registerButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                guard let username = owner.username, let socialType = owner.socialType else { return }
                Task {
                    guard let (data, response) = try? await AuthAPI.register(username: username, socialType: socialType, memberType: 1, nickname: "z3ro"), let httpResponse = response as? HTTPURLResponse else { return }
                    let statusCode = httpResponse.statusCode
                    
                    switch statusCode {
                    case 200..<300:
                        let dto = try? JSONDecoder().decode(BaseResponseDTO<AccessTokenDTO>.self, from: data)
                        guard let accessToken = dto?.data?.accessToken else { return }
                        print("✅ register success!")
                        print("🪙 accessToken: ", accessToken)
                    case 400:
                        let dto = try? JSONDecoder().decode(BaseResponseDTO<String>.self, from: data)
                        guard let messages = dto?.messages else { return }
                        print("⚠️ failed register")
                        print("messages: ", messages)
                    default:
                        print("wtf??: ", statusCode)
                        let dto = try? JSONDecoder().decode(BaseResponseDTO<String>.self, from: data)
                        guard let messages = dto?.messages else { return }
                        print(messages)
                        return
                    }
                }
            })
            .disposed(by: disposeBag)
        
        unRegisterButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                Task {
                    try await UserApi.shared.unlink()
                }
            })
            .disposed(by: disposeBag)
    }
}
