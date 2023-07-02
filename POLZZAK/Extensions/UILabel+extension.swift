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
    
    func setLabel(style: LabelStyleProtocol) {
        let attributedString = NSMutableAttributedString(string: style.text)
        
        let basicAttributes: [NSAttributedString.Key: Any] = [
            .font: style.font,
            .foregroundColor: style.textColor
        ]
        attributedString.addAttributes(basicAttributes, range: NSRange(location: 0, length: style.text.count))
        
        if let emphasisStyle = style as? EmphasisLabelStyle,
           let emphasisFont = emphasisStyle.emphasisFont,
           let emphasisColor = emphasisStyle.emphasisColor,
           let emphasisRange = emphasisStyle.emphasisRange {
            let emphasisAttributes: [NSAttributedString.Key: Any] = [
                .font: emphasisFont,
                .foregroundColor: emphasisColor
            ]
            attributedString.addAttributes(emphasisAttributes, range: emphasisRange)
        }
        
        self.textAlignment = style.textAlignment
        self.backgroundColor = style.backgroundColor
        self.attributedText = attributedString
    }
    
}
