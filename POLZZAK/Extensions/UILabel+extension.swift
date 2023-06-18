//
//  UILabel+extension.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/05/14.
//

import UIKit

extension UILabel {
    func setLabel(text: String = "", textColor: UIColor, font: UIFont, textAlignment: NSTextAlignment = .natural, backgroundColor: UIColor = .clear) {
        self.text = text
        self.textColor = textColor
        self.font = font
        self.textAlignment = textAlignment
        self.backgroundColor = backgroundColor
    }
    
    func setLabel(with labelStyle: LabelStyle) {
        self.text = labelStyle.text
        self.textColor = labelStyle.textColor
        self.font = labelStyle.font
        self.textAlignment = labelStyle.textAlignment
        self.backgroundColor = labelStyle.backgroundColor
    }
    
    func setEmphasisLabel(style: EmphasisLabelStyle) {
        
        let totalString = style.text + style.rest
        let attributedString = NSMutableAttributedString(string: totalString)
        
        let textRange = NSRange(location: 0, length: style.text.count)
        attributedString.addAttribute(.font, value: style.textFont, range: textRange)
        attributedString.addAttribute(.foregroundColor, value: style.textColor, range: textRange)
        
        if style.rest.count > 0 {
            let restRange = NSRange(location: style.text.count, length: style.rest.count)
            attributedString.addAttribute(.font, value: style.restFont, range: restRange)
            attributedString.addAttribute(.foregroundColor, value: style.restColor, range: restRange)
        }
        
        self.textAlignment = style.textAlignment
        self.backgroundColor = style.backgroundColor
        self.attributedText = attributedString
    }
}
