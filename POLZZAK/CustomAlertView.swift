//
//  CustomAlertView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/15.
//

import UIKit
import SnapKit

final class CustomAlertView: UIView {
    var firstButtonAction: (() -> Void)?
    var secondButtonAction: (() -> Void)?
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .white
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let firstButton = UIButton()
    private let secondButton = UIButton()
    let loadingView = LoadingView()
    private let alertStyle: AlertStyle?
    
    init(frame: CGRect = .zero, alertStyle: AlertStyle) {
        self.alertStyle = alertStyle
        super.init(frame: frame)
        setAlertView(alertStyle: alertStyle)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomAlertView {
    private func setAlertView(alertStyle: AlertStyle) {
        label.setEmphasisLabel(style: alertStyle.emphasisLabelStyle)
        setCustomView(cornerRadius: alertStyle.borderStyle.cornerRadius)
        
        let buttons = alertStyle.buttons
        for (index, labelStyle) in buttons.enumerated() {
            if index == 0 {
                buttonStackView.addArrangedSubview(firstButton)
                firstButton.setCustomButton(labelStyle: labelStyle, borderStyle: alertStyle.buttonBorderStyle)
                firstButton.addTarget(self, action: #selector(firstButtonTapped), for: .touchUpInside)
            } else if index == 1 {
                buttonStackView.addArrangedSubview(secondButton)
                secondButton.setCustomButton(labelStyle: labelStyle, borderStyle: alertStyle.buttonBorderStyle)
                buttonStackView.spacing = alertStyle.buttonSpacing
                secondButton.addTarget(self, action: #selector(secondButtonTapped), for: .touchUpInside)
            }
        }
    }
    
    private func setUI() {
        backgroundColor = .white
        
        [label, buttonStackView, loadingView].forEach {
            addSubview($0)
        }
        
        label.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.centerX.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        loadingView.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(24)
            $0.bottom.equalToSuperview().inset(40)
            $0.width.equalTo(loadingView.snp.height)
            $0.centerX.equalToSuperview()
        }
    }
    
    func startLoading() {
        buttonStackView.isHidden = true
        loadingView.startRotating()
    }
    
    @objc private func firstButtonTapped() {
        firstButtonAction?()
    }
    
    @objc private func secondButtonTapped() {
        if true == alertStyle?.isLoading {
            startLoading()
        }
        secondButtonAction?()
    }
}
