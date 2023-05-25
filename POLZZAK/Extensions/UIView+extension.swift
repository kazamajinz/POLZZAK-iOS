//
//  UIView+extension.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/05/20.
//

import UIKit

extension UIView {
    func setCustomView(backgroundColor: UIColor = .white, cornerRadius: CGFloat = 0.0, borderWidth: CGFloat = 0.0, borderColor: UIColor = .clear, masksToBounds: Bool = true) {
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.masksToBounds = masksToBounds
    }
}
