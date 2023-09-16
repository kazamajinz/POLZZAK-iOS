//
//  CouponReceiveAlertView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/10.
//

import Foundation

import UIKit

class CouponReceiveAlertView: AlertButtonView {
    
    enum Constants {
        static let closeButton = "취소"
        static let confirmButton = "네, 받았어요!"
    }
    
    let loadingView = LoadingView()
    
    init() {
        super.init(buttonStyle: .double, contentStyle: .titleWithContent)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        titleLabel.setLabel(textColor: .gray800, font: .subtitle18Sbd, textAlignment: .center)
        contentLabel.setLabel(text: "선물을 실제로 전달받았나요?", textColor: .gray500, font: .body16Md)
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
