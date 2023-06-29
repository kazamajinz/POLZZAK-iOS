//
//  RegisterUserTypeViewController.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/29.
//

import Combine
import UIKit

import CombineCocoa

class RegisterUserTypeViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private let descriptionLabel1: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .gray800
        label.font = .title4
        label.text = "어떤 회원으로 활동하시겠어요?"
        return label
    }()
    
    private let descriptionLabel2: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .gray600
        label.font = .body1
        label.text = "나중에 변경이 불가하니 신중하게 선택해 주세요"
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    private let parentButton = UserTypeSelectButton(userType: .parent)
    private let childButton = UserTypeSelectButton(userType: .child)
    
    private let nextButton: RegisterNextButton = {
        let nextButton = RegisterNextButton()
        nextButton.isEnabled = false
        return nextButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureView()
        configureBinding()
    }
    
    private func configureLayout() {
        [labelStackView, buttonStackView, nextButton].forEach {
            view.addSubview($0)
        }
        
        [descriptionLabel1, descriptionLabel2].forEach {
            labelStackView.addArrangedSubview($0)
        }
        
        [parentButton, childButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(buttonStackView.snp.top).offset(-89)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(230)
        }
        
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(36)
        }
    }
    
    private func configureView() {
        view.backgroundColor = .gray100
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    private func configureBinding() {
        parentButton.tapPublisher
            .sink { [weak self] _ in
                self?.determineButtonSelection(parentButtonSelected: true)
            }
            .store(in: &cancellables)
        
        childButton.tapPublisher
            .sink { [weak self] _ in
                self?.determineButtonSelection(parentButtonSelected: false)
            }
            .store(in: &cancellables)
        
        parentButton.tapPublisher.merge(with: childButton.tapPublisher)
            .sink { [weak self] _ in
                guard let self else { return }
                self.nextButton.isEnabled = self.parentButton.isSelected || self.childButton.isSelected
            }
            .store(in: &cancellables)
        
        nextButton.tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                if self.parentButton.isSelected {
                    self.navigationController?.pushViewController(RegisterParentTypeViewController(), animated: true)
                } else if self.childButton.isSelected {
                    self.navigationController?.pushViewController(RegisterNicknameViewController(), animated: true)
                }
            }
            .store(in: &cancellables)
    }
    
    private func determineButtonSelection(parentButtonSelected: Bool) {
        parentButton.isSelected = parentButtonSelected
        childButton.isSelected = !parentButtonSelected
    }
}
