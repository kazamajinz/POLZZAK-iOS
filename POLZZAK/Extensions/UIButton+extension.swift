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
    
    func setCustomButton(labelStyle: LabelStyle? = nil, borderStyle: BorderStyle? = nil, backgroundColor: UIColor = .white) {
        if let label = labelStyle {
            self.setTitle(label.title, for: .normal)
            self.setTitleColor(label.titleColor, for: .normal)
            self.titleLabel?.font = label.font
        }
        
        if let border = borderStyle {
            self.layer.borderColor = border.color.cgColor
            self.layer.cornerRadius = border.cornerRadius
            self.layer.borderWidth = border.width
            self.layer.masksToBounds = border.masksToBounds
        }
        
        self.backgroundColor = backgroundColor
    }
}
