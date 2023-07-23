//
//  LabelStyleBuilder.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/07/24.
//

import UIKit

final class LabelStyleBuilder: EmphasisLabelStyleProtocol {
    var text: String = ""
    var textColor: UIColor = .black
    var font: UIFont = .systemFont(ofSize: 14)
    var textAlignment: NSTextAlignment = .natural
    var backgroundColor: UIColor = .clear
    var emphasisRangeArray: [NSRange]? = nil
    var emphasisColor: UIColor? = nil
    var emphasisFont: UIFont? = nil
    
    func setText(_ text: String) -> Self {
        self.text = text
        return self
    }
    
    func setTextAlignment(_ textAlignment: NSTextAlignment) -> Self {
        self.textAlignment = textAlignment
        return self
    }
    
    func setBackgroundColor(_ color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }
    
    func setTextColor(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }
    
    func setFont(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    func setEmphasisRangeArray(_ rangeArray: [NSRange]) -> Self {
        self.emphasisRangeArray = rangeArray
        return self
    }
    
    func setEmphasisColor(_ color: UIColor) -> Self {
        self.emphasisColor = color
        return self
    }
    
    func setEmphasisFont(_ font: UIFont) -> Self {
        self.emphasisFont = font
        return self
    }

    func build() -> EmphasisLabelStyle {
        return EmphasisLabelStyle(
            text: text,
            textColor: textColor,
            font: font,
            textAlignment: textAlignment,
            backgroundColor: backgroundColor,
            emphasisRangeArray: emphasisRangeArray,
            emphasisColor: emphasisColor,
            emphasisFont: emphasisFont
        )
    }
}
