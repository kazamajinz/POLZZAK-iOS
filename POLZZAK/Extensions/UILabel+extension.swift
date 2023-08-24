//
//  UILabel+extension.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/05/14.
//

import UIKit

extension UILabel {
    func setLabel(text: String? = nil, textColor: UIColor, font: UIFont, textAlignment: NSTextAlignment = .natural, backgroundColor: UIColor = .clear) {
        if let text = text {
            self.text = text
        }
        self.textColor = textColor
        self.font = font
        self.textAlignment = textAlignment
        self.backgroundColor = backgroundColor
    }
    
    func setEmphasisRanges(_ ranges: [NSRange], color: UIColor, font: UIFont) {
        let mutableAttributedString = NSMutableAttributedString(string: self.text ?? "")
        ranges.forEach { range in
            mutableAttributedString.addAttributes([.foregroundColor: color, .font: font], range: range)
        }
        self.attributedText = mutableAttributedString
    }
    
    func setLineSpacing(spacing: CGFloat) {
        guard let text = self.text else { return }
        
        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        attributeString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: style,
            range: NSMakeRange(0, attributeString.length)
        )
        
        self.attributedText = attributeString
    }
}

extension UILabel {
    func setByCharWrapping(text: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byCharWrapping
        let attributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        self.attributedText = attributedString
    }
    
    func setStyledText(
        text: String,
        emphasisRanges: [NSRange],
        color: UIColor,
        font: UIFont,
        lineBreakMode: NSLineBreakMode
    ) {
        let mutableAttributedString = NSMutableAttributedString(string: text)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode
        mutableAttributedString.addAttributes([.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: text.count))
        
        emphasisRanges.forEach { range in
            mutableAttributedString.addAttributes([.foregroundColor: color, .font: font], range: range)
        }
        
        self.attributedText = mutableAttributedString
    }
}


