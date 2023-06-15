//
//  UIStyleType.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/15.
//

import UIKit

struct LabelStyle {
    let title: String
    let titleColor: UIColor
    let font: UIFont
}

struct BorderStyle {
    let color: UIColor
    let width: CGFloat
    let cornerRadius: CGFloat
    let masksToBounds: Bool
    
    init(color: UIColor = .white, width: CGFloat = 0.0, cornerRadius: CGFloat = 0.0, masksToBounds: Bool = true) {
        self.color = color
        self.width = width
        self.cornerRadius = cornerRadius
        self.masksToBounds = masksToBounds
    }
}
