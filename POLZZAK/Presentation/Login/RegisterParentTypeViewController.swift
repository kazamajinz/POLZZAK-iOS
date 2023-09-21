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
    
    private let selectView: ParentTypeSelectView
    
    private let nextButton: RegisterNextButton = {
        let nextButton = RegisterNextButton()
        nextButton.isEnabled = false
        return nextButton
    }()
    
    init(registerModel: RegisterModel) {
        self.registerModel = registerModel
        self.selectView = .init(types: registerModel.memberTypeDetailList ?? [])
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
    }
    
    private func configureBinding() {
        selectView.$currentType.sink { [weak self] type in
            guard let self else { return }
            nextButton.isEnabled = type?.memberTypeDetailId != nil
            registerModel.memberType = type?.memberTypeDetailId
        }
        .store(in: &cancellables)
        
        nextButton.tapPublisher
            .sink { [weak self] in
                guard let self else { return }
                let vc = RegisterNicknameViewController(registerModel: registerModel)
                navigationController?.pushViewController(vc, animated: true)
            }
            .store(in: &cancellables)
    }
}
