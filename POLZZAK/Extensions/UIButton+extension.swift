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
}
