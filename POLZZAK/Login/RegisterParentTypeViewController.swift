//
//  RegisterParentTypeViewController.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/29.
//

import Combine
import UIKit

import CombineCocoa
import SnapKit

final class RegisterParentTypeViewController: UIViewController {
    enum Constants {
        static let basicInset: CGFloat = 16
    }
    
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
        label.font = .title22Bd
        label.numberOfLines = 2
        label.text = "함께 활동할 아이와의\n가족관계를 알려주세요"
        label.setLineSpacing(spacing: 7)
        return label
    }()
    
    private let descriptionLabel2: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .gray600
        label.font = .body15Md
        label.numberOfLines = 2
        label.text = "설정한 가족관계는 뱃지로 설정돼요\n나중에 변경이 불가하니 신중하게 선택해 주세요"
        label.setLineSpacing(spacing: 5)
        return label
    }()
    
    private let selectView = ParentTypeSelectView(types: ["엄마", "아빠", "언니", "오빠", "누나", "형", "선택해주세요", "할머니", "할아버지", "이모", "고모", "삼촌", "보호자"])
    
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
        [labelStackView, selectView, nextButton].forEach {
            view.addSubview($0)
        }
        
        [descriptionLabel1, descriptionLabel2].forEach {
            labelStackView.addArrangedSubview($0)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.horizontalEdges.equalToSuperview().inset(Constants.basicInset)
        }
        
        selectView.snp.makeConstraints { make in
            make.top.equalTo(labelStackView.snp.bottom).offset(63)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(300)
        }
        
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constants.basicInset)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.basicInset)
            make.height.equalTo(50)
        }
    }
    
    private func configureView() {
        view.backgroundColor = .gray100
        UIView.performWithoutAnimation {
            selectView.layoutIfNeeded()
            selectView.scrollToItem(at: IndexPath(item: 6, section: 0), at: .centeredVertically, animated: false)
            selectView.configureCurrentType(isInitial: true)
        }
    }
    
    private func configureBinding() {
        selectView.$currentType.sink { [weak self] type in
            self?.nextButton.isEnabled = type != nil
            guard let type else { return }
//            self?.viewModel.parentType = type
        }
        .store(in: &cancellables)
        
        nextButton.tapPublisher
            .sink { [weak self] _ in
                let vc = RegisterNicknameViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            .store(in: &cancellables)
    }
}
