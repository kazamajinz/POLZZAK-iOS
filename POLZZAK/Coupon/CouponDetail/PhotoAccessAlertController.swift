//
//  PhotoAccessAlertController.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/21.
//

import UIKit

class PhotoAccessAlertController: AlertButtonView {
    
    enum Constants {
        static let contentLabel = "설정 > 폴짝 > 사진에서\n접근권한을 '사진만 추가'로\n변경해 주세요"
        static let closeButton = "취소"
        static let confirmButton = "설정하기"
    }
    
    init() {
        super.init(buttonStyle: .double, contentStyle: .onlyTitle)
        
        setUI()
        setAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        titleLabel.setLabel(text: Constants.contentLabel, textColor: .gray700, font: .subtitle18Sbd, textAlignment: .center)
        closeButton.text = Constants.closeButton
        confirmButton.text = Constants.confirmButton
    }
    
    private func setAction() {
        secondButtonAction = {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            self.dismiss(animated: false, completion: nil)
        }
    }
}
