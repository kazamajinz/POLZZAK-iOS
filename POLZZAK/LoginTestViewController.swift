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

        let api = TokenTarget.checkToken
        let networkService = NetworkService()
        Task {
            do {
                let data = try await networkService.requestData(responseType: TokenResponseDTO.self, with: api)
                print(data.code, data.data, data.messages)
            } catch {
                print(error)
            }
        }
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
                    do {
                        let oAuthAccessToken = try await KakaoLoginAPI.loginWithKakao()
                        owner.oAuthAccessToken = oAuthAccessToken
                        print("oAuthAccessToken", oAuthAccessToken)
                    } catch {
                        print(error)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}
