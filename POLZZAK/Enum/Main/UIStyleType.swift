//
//  UIStyleType.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/15.
//

import UIKit

struct LabelStyle {
    let text: String
    let textColor: UIColor
    let font: UIFont
    let textAlignment: NSTextAlignment
    let backgroundColor: UIColor
    
    init(text: String, textColor: UIColor = .white, font: UIFont, textAlignment: NSTextAlignment = .natural, backgroundColor: UIColor = .white) {
        self.text = text
        self.textColor = textColor
        self.font = font
        self.textAlignment = textAlignment
        self.backgroundColor = backgroundColor
    }
}

struct EmphasisLabelStyle {
    let text: String
    let textFont: UIFont
    let textColor: UIColor
    let rest: String
    let restFont: UIFont
    let restColor: UIColor
    let textAlignment: NSTextAlignment
    let backgroundColor: UIColor
    
    init(text: String, textFont: UIFont, textColor: UIColor, rest: String, restFont: UIFont, restColor: UIColor, textAlignment: NSTextAlignment = .natural, backgroundColor: UIColor = .clear) {
        self.text = text
        self.textFont = textFont
        self.textColor = textColor
        self.rest = rest
        self.restFont = restFont
        self.restColor = restColor
        self.textAlignment = textAlignment
        self.backgroundColor = backgroundColor
    }
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
