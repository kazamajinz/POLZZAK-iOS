//
//  RegisterTermsViewController.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/07/21.
//

import Combine
import UIKit

import CombineCocoa
import SnapKit

final class RegisterTermsViewController: UIViewController {
    enum Constants {
        static let basicInset: CGFloat = 16
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .title22Bd
        label.textColor = .gray800
        label.text = "먼저 약관 동의가 필요해요"
        return label
    }()
    
    private let agreementCheckView = AgreementCheckView()
    
    private let nextButton = RegisterNextButton()
    
    private var agreementCheckViewHeightConstraint: Constraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLayout()
        configureBinding()
        setTerms()
    }
    
    private func configureView() {
        view.backgroundColor = .gray100
    }
    
    private func configureLayout() {
        [descriptionLabel, agreementCheckView, nextButton].forEach {
            view.addSubview($0)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.horizontalEdges.equalToSuperview().inset(Constants.basicInset)
        }
        
        agreementCheckView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(Constants.basicInset)
            make.horizontalEdges.equalToSuperview().inset(Constants.basicInset)
            agreementCheckViewHeightConstraint = make.height.equalTo(400).constraint
        }
        
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constants.basicInset)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.basicInset)
            make.height.equalTo(50)
        }
    }
    
    private func configureBinding() {
        agreementCheckView.allTermsAccepted
            .sink { [weak self] allTermsAccepted in
                self?.nextButton.isEnabled = allTermsAccepted
            }
            .store(in: &cancellables)
        
        nextButton.tapPublisher
            .sink { [weak self] in
                let vc = RegisterUserTypeViewController(registerModel: .init())
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func setTerms() {
        agreementCheckView.setTerms(terms: [
            [.init(title: "모두 동의", type: .main, normalTextColor: .gray800, backgroundColor: .blue150),
             .init(title: "서비스 이용약관에 동의합니다.", contentsURL: .init(string: "d"), type: .sub),
             .init(title: "개인정보처리방침에 동의합니다.", contentsURL: .init(string: "d"), type: .sub)]
        ])
        
        let height = agreementCheckView.contentSize.height
        agreementCheckViewHeightConstraint?.deactivate()
        agreementCheckView.snp.makeConstraints { make in
            agreementCheckViewHeightConstraint = make.height.equalTo(height).constraint
        }
    }
}
