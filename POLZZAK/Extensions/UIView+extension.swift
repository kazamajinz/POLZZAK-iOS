//
//  UIView+extension.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/05/20.
//

import UIKit

extension UIView {
    func setCustomView(radius: CGFloat, color: UIColor = .white) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.backgroundColor = color
    }
}
