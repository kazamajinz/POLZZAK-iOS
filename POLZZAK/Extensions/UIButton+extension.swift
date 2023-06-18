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
}
