//
//  UIStackView+extension.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/22.
//

import UIKit

extension UIStackView {
    func setStackView(axis: NSLayoutConstraint.Axis, spacing: CGFloat) {
        self.axis = axis
        self.spacing = spacing
    }
}
