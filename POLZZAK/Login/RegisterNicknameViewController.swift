//
//  RegisterNicknameViewController.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/29.
//

import UIKit

class RegisterNicknameViewController: UIViewController {
    private let descriptionLabel1: UILabel = {
        let label = UILabel()
        label.text = "닉네임을 설정해주세요"
        label.textAlignment = .left
        label.textColor = .gray800
        label.font = .title4
        return label
    }()
    
    private let descriptionLabel2: UILabel = {
        let label = UILabel()
        label.text = "나중에 자유롭게 수정할 수 있어요"
        label.textAlignment = .left
        label.textColor = .gray600
        label.font = .body1
        return label
    }()
    
    private let nicknameDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "한글, 영문(대소문자 구별), 숫자 사용 가능 / 특수문자, 공백 불가"
        label.textAlignment = .left
        label.textColor = .gray500
        label.font = .body4
        return label
    }()
    
    private let nicknameChecker = NicknameChecker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureView()
        configureBinding()
    }
    
    private func configureLayout() {
        view.addSubview(nicknameChecker)
        
        nicknameChecker.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    private func configureView() {
        view.backgroundColor = .gray100
    }
    
    private func configureBinding() {
        
    }
}
