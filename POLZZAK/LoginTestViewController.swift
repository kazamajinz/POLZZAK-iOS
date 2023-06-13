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
                    guard let (data, response) = try? await LoginAPI().login(), let httpResponse = response as? HTTPURLResponse else { return }
                    let statusCode = httpResponse.statusCode
                    
                    switch statusCode {
                    case 200..<300:
                        fallthrough
                    default:
                        return
                    }
                    
                }
            })
            .disposed(by: disposeBag)
    }
}
