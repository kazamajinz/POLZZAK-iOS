//
//  CustomAlertViewController.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/15.
//

import UIKit
import SnapKit

final class CustomAlertViewController: UIViewController {
    enum ButtonStyle {
        case singleButton
        case doubleButton
    }
    
    var firstButtonAction: (() -> Void)?
    var secondButtonAction: (() -> Void)?
    
    private let width = UIApplication.shared.width * 343.0 / 375.0
    private let height = UIApplication.shared.width * 343.0 / 375.0 * 196.0 / 343.0
    
    let customAlertView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .gray700
        label.font = .body18Md
        label.textAlignment = .center
        return label
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .white
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 11
        return stackView
    }()
    
    let firstButton: UIButton = {
        let button = UIButton()
        button.setTitle("아니요", for: .normal)
        button.titleLabel?.font = .subtitle16Sbd
        button.backgroundColor = .gray300
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    let secondButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .subtitle16Sbd
        button.backgroundColor = .blue500
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    private let loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.isHidden = true
        return loadingView
    }()
    
    var buttonStyle: ButtonStyle = .doubleButton
    
    var isLoadingView: Bool = false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAction()
        setSecondButton()
    }
}

extension CustomAlertViewController {
    private func setUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        view.addSubview(customAlertView)
        
        customAlertView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(width)
            $0.height.equalTo(height)
        }
        
        [contentLabel, buttonStackView, loadingView].forEach {
            customAlertView.addSubview($0)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.centerX.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        loadingView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(24)
            $0.bottom.equalToSuperview().inset(40)
            $0.width.equalTo(loadingView.snp.height)
            $0.centerX.equalToSuperview()
        }
        
        buttonStackView.addArrangedSubview(firstButton)
    }
    
    private func setAction() {
        firstButton.addTarget(self, action: #selector(firstButtonTapped), for: .touchUpInside)
    }
    
    private func setSecondButton() {
        if buttonStyle == .doubleButton {
            buttonStackView.addArrangedSubview(secondButton)
            secondButton.addTarget(self, action: #selector(secondButtonTapped), for: .touchUpInside)
        }
    }
    
    func startLoading() {
        buttonStackView.isHidden = true
    }
    
    @objc private func firstButtonTapped() {
        firstButtonAction?()
        dismiss(animated: false)
    }
    
    @objc private func secondButtonTapped() {
        if true == isLoadingView {
            startLoading()
        }
        secondButtonAction?()
        dismiss(animated: false)
    }
}
