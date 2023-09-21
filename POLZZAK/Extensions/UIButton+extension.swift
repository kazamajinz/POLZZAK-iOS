//
//  UIButton+extension.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/13.
//

import UIKit

extension UIButton {
    func setTitleLabel(title: String = "", titleColor: UIColor, font: UIFont, backgroundColor: UIColor = .white) {
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = font
    }
    
    //TODO: - 통일후 지울예정
    func setTitleLabel(title: String = "", color: UIColor, font: UIFont, backgroundColor: UIColor = .white) {
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        self.setTitleColor(color, for: .normal)
        self.titleLabel?.font = font
    }
    
    func setUnderlinedTitle(text: String, textColor: UIColor, font: UIFont, textAlignment: NSTextAlignment = .center) {
        let attributedString = NSAttributedString(string: text, attributes: [
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ])
        setAttributedTitle(attributedString, for: .normal)
        self.setTitleColor(textColor, for: .normal)
        self.titleLabel?.font = font
        self.backgroundColor = backgroundColor
    }
}

