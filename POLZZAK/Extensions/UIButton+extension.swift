//
//  UIButton+extension.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/13.
//

import UIKit

extension UIButton {
    func setTitleLabel(title: String, color: UIColor, font: UIFont) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(color, for: .normal)
        self.titleLabel?.font = font
    }
    
    func setButtonView(backgroundColor: UIColor = .white, borderColor: UIColor = .black, cornerRadius: CGFloat = 0, borderWidth: CGFloat = 0.0,  masksToBounds: Bool = true) {
        self.backgroundColor = backgroundColor
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.masksToBounds = masksToBounds
    }
    
    func setCustomButton(labelStyle: LabelStyle? = nil, borderStyle: BorderStyle? = nil) {
        if let label = labelStyle {
            self.setTitle(label.text, for: .normal)
            self.setTitleColor(label.textColor, for: .normal)
            self.titleLabel?.font = label.font
            self.backgroundColor = label.backgroundColor
        }
        
        if let border = borderStyle {
            self.layer.borderColor = border.color.cgColor
            self.layer.cornerRadius = border.cornerRadius
            self.layer.borderWidth = border.width
            self.layer.masksToBounds = border.masksToBounds
        }
    }
    
    func setUnderlinedTitle(labelStyle: LabelStyle) {
        let attributedString = NSAttributedString(string: labelStyle.text, attributes: [
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ])
        setAttributedTitle(attributedString, for: .normal)
        self.setTitleColor(labelStyle.textColor, for: .normal)
        self.titleLabel?.font = labelStyle.font
        self.backgroundColor = labelStyle.backgroundColor
    }
}

