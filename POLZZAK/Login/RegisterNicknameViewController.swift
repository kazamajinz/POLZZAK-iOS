//
//  RegisterNicknameViewController.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/29.
//

import UIKit
import Combine

final class RegisterNicknameViewController: UIViewController {
    enum Constants {
        static let basicInset: CGFloat = 16
    }
    
    private let registerModel: RegisterModel
    
    private var cancellables = Set<AnyCancellable>()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
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
    
    private let nicknameChecker = NicknameCheckView()
    
    private let nextButton: RegisterNextButton = {
        let nextButton = RegisterNextButton()
        nextButton.isEnabled = false
        return nextButton
    }()
    
    init(registerModel: RegisterModel) {
        self.registerModel = registerModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureView()
        configureBinding()
    }
    
    private func configureLayout() {
        [labelStackView, nicknameDescriptionLabel, nicknameChecker, nextButton].forEach {
            view.addSubview($0)
        }
        
        [descriptionLabel1, descriptionLabel2].forEach {
            labelStackView.addArrangedSubview($0)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.horizontalEdges.equalToSuperview().inset(Constants.basicInset)
        }
        
        nicknameDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(labelStackView.snp.bottom).offset(58)
            make.horizontalEdges.equalToSuperview().inset(Constants.basicInset)
        }

        nicknameChecker.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constants.basicInset)
            make.top.equalTo(nicknameDescriptionLabel.snp.bottom).offset(10)
        }
        
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constants.basicInset)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.basicInset)
            make.height.equalTo(50)
        }
    }
    
    private func configureView() {
        view.backgroundColor = .gray100
    }
    
    private func configureBinding() {
        nicknameChecker.$validText
            .sink { [weak self] validNickname in
                guard let self else { return }
                nextButton.isEnabled = validNickname != nil
                registerModel.nickname = validNickname
            }
            .store(in: &cancellables)
        
        nextButton.tapPublisher
            .sink { [weak self] in
                guard let self else { return }
                let vc = RegisterProfileImageViewController(registerModel: registerModel)
                navigationController?.pushViewController(vc, animated: true)
            }
            .store(in: &cancellables)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        view.addGestureRecognizer(tapGesture)
        
        tapGesture.tapPublisher
            .sink { [weak self] _ in
                self?.view.endEditing(true)
            }
            .store(in: &cancellables)
    }
}
