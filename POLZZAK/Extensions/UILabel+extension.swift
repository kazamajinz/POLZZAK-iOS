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
    
    func setLabelForRange(
        text: String, textFont: UIFont, textColor: UIColor,
        rest: String, restFont: UIFont, restColor: UIColor,
        textAlignment: NSTextAlignment = .natural, backgroundColor: UIColor = .clear) {
        
        let totalString = text + rest
        let attributedString = NSMutableAttributedString(string: totalString)
        
        let textRange = NSRange(location: 0, length: text.count)
        attributedString.addAttribute(.font, value: textFont, range: textRange)
        attributedString.addAttribute(.foregroundColor, value: textColor, range: textRange)
        
        if rest.count > 0 {
            let restRange = NSRange(location: text.count, length: rest.count)
            attributedString.addAttribute(.font, value: restFont, range: restRange)
            attributedString.addAttribute(.foregroundColor, value: restColor, range: restRange)
        }
        
        self.textAlignment = textAlignment
        self.backgroundColor = backgroundColor
        self.attributedText = attributedString
    }
}
