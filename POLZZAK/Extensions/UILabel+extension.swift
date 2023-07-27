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
    
    @discardableResult
    func setEmphasisRanges(_ ranges: [NSRange], color: UIColor, font: UIFont) -> Self {
        let mutableAttributedString = NSMutableAttributedString(string: self.text ?? "")
        ranges.forEach { range in
            mutableAttributedString.addAttributes([.foregroundColor: color, .font: font], range: range)
        }
        self.attributedText = mutableAttributedString
        return self
    }
}

