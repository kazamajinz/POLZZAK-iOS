//
//  AlertButtonView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/20.
//

import UIKit
import SnapKit

class AlertButtonView: BaseAlertViewController {
    enum ButtonStyle {
        case single
        case double
    }
    
    enum ContentStyle {
        case onlyTitle
        case titleWithContent
    }
    
    enum Constants {
        static let buttonPadding = UIEdgeInsets(top: 14, left: 24, bottom: 14, right: 24)
    }
    
    private let buttonStyle: ButtonStyle
    private let contentStyle: ContentStyle
    
    typealias ButtonAction = () -> Void
    var firstButtonAction: ButtonAction?
    @MainActor var secondButtonAction: ButtonAction?
    var bottomConstraint: Constraint?
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 40
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 11
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let closeButton: PaddedLabel = {
        let closeButton = PaddedLabel(padding: Constants.buttonPadding)
        closeButton.textColor = .white
        closeButton.textAlignment = .center
        closeButton.font = .subtitle16Sbd
        closeButton.layer.cornerRadius = 8
        closeButton.layer.masksToBounds = true
        closeButton.isUserInteractionEnabled = true
        return closeButton
    }()
    
    let confirmButton: PaddedLabel = {
        let confirmButton = PaddedLabel(padding: Constants.buttonPadding)
        confirmButton.backgroundColor = .blue500
        confirmButton.textColor = .white
        confirmButton.textAlignment = .center
        confirmButton.font = .subtitle16Sbd
        confirmButton.layer.cornerRadius = 8
        confirmButton.layer.masksToBounds = true
        confirmButton.isUserInteractionEnabled = true
        return confirmButton
    }()
    
    init(buttonStyle: ButtonStyle, contentStyle: ContentStyle) {
        self.buttonStyle = buttonStyle
        self.contentStyle = contentStyle
        
        super.init()
        
        setupButtonStyles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setButtonActions()
    }
    
    private func setUI() {
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.leading.trailing.equalToSuperview().inset(16)
            bottomConstraint = $0.bottom.equalToSuperview().inset(16).constraint
        }
        
        [contentStackView, buttonStackView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        contentStackView.addArrangedSubview(titleLabel)
        if contentStyle == .titleWithContent {
            contentStackView.addArrangedSubview(contentLabel)
        }
        
        buttonStackView.addArrangedSubview(closeButton)
    }
    
    private func setupButtonStyles() {
        switch buttonStyle {
        case .single:
            setupSingleButtonStyle()
        case .double:
            setupDoubleButtonStyle()
        }
    }
    
    private func setupSingleButtonStyle() {
        closeButton.backgroundColor = .blue500
        closeButton.textColor = .white
        closeButton.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
    }
    
    private func setupDoubleButtonStyle() {
        closeButton.backgroundColor = .gray300
        closeButton.textColor = .white
        confirmButton.backgroundColor = .blue500
        buttonStackView.addArrangedSubview(confirmButton)
    }
    
    private func setButtonActions() {
        closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFirstButtonTap)))
        confirmButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSecondButtonTap)))
    }
    
    @objc private func handleFirstButtonTap() {
        dismiss(animated: false)
        Task {
            firstButtonAction?()
        }
    }
    
    @objc private func handleSecondButtonTap() {
        Task {
            secondButtonAction?()
        }
    }
}
