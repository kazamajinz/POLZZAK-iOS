//
//  UIStyleType.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/15.
//

import UIKit

protocol LabelStyleProtocol {
    var text: String { get }
    var textColor: UIColor { get }
    var font: UIFont { get }
    var textAlignment: NSTextAlignment { get }
    var backgroundColor: UIColor { get }
}

struct LabelStyle: LabelStyleProtocol {
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

struct EmphasisLabelStyle: LabelStyleProtocol {
    let text: String
    let textColor: UIColor
    let font: UIFont
    let textAlignment: NSTextAlignment
    let backgroundColor: UIColor
    
    let emphasisRange: NSRange?
    let emphasisColor: UIColor?
    let emphasisFont: UIFont?
    
    init(text: String, textColor: UIColor, font: UIFont, textAlignment: NSTextAlignment = .natural, backgroundColor: UIColor = .clear, emphasisRange: NSRange? = nil, emphasisColor: UIColor? = nil, emphasisFont: UIFont? = nil) {
        self.text = text
        self.textColor = textColor
        self.font = font
        self.textAlignment = textAlignment
        self.backgroundColor = backgroundColor
        
        self.emphasisRange = emphasisRange
        self.emphasisColor = emphasisColor
        self.emphasisFont = emphasisFont
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
