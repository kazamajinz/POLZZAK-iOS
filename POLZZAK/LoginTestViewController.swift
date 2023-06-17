//
//  LoginTestViewController.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/10.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class LoginTestViewController: UIViewController {
    
    private var disposeBag = DisposeBag()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("카카오 로그인", for: .normal)
        return button
    }()
    
    private var oAuthAccessToken: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
        bind()
    }
    
    private func configure() {
        view.addSubview(loginButton)
        
        loginButton.snp.makeConstraints { make in
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
                        print("🪙 accessToken: ", accessToken)
                    case 400:
                        let dto = try? JSONDecoder().decode(BaseResponseDTO<NeedRegisterDTO>.self, from: data)
                        guard let needRegisterDTO = dto?.data else { return }
                        print("⚠️ need register")
                        print("username: ", needRegisterDTO.username)
                        print("socialType: ", needRegisterDTO.socialType)
                    default:
                        return
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}
