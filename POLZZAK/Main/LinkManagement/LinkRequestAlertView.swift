//
//  LinkRequestAlertView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/31.
//

import UIKit

class LinkRequestAlertView: AlertButtonView {
    
    enum Constants {
        static let closeButton = "아니요"
        static let confirmButton = "네"
    }
    
    let loadingView = LoadingView()
    
    init() {
        super.init(buttonStyle: .double, contentStyle: .onlyTitle)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        titleLabel.setLabel(textColor: .gray700, font: .body18Md, textAlignment: .center)
        closeButton.text = Constants.closeButton
        confirmButton.text = Constants.confirmButton
        
        loadingView.snp.makeConstraints {
            $0.width.height.equalTo(50)
        }
        
        confirmButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showLoading)))
    }
    
    @objc private func showLoading() {
        buttonStackView.removeFromSuperview()
        stackView.addArrangedSubview(loadingView)
        stackView.spacing = 24
        bottomConstraint?.update(inset: 40)
        
        Task {
            secondButtonAction?()
        }
    }
}
