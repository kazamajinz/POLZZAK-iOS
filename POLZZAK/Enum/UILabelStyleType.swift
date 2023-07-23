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

protocol EmphasisLabelStyleProtocol: LabelStyleProtocol {
    var emphasisRangeArray: [NSRange]? { get }
    var emphasisColor: UIColor? { get }
    var emphasisFont: UIFont? { get }
}

struct EmphasisLabelStyle: EmphasisLabelStyleProtocol {
    let text: String
    let textColor: UIColor
    let font: UIFont
    let textAlignment: NSTextAlignment
    let backgroundColor: UIColor
    let emphasisRangeArray: [NSRange]?
    let emphasisColor: UIColor?
    let emphasisFont: UIFont?

    init(text: String, textColor: UIColor, font: UIFont, textAlignment: NSTextAlignment = .natural, backgroundColor: UIColor = .clear, emphasisRangeArray: [NSRange]? = nil, emphasisColor: UIColor? = nil, emphasisFont: UIFont? = nil) {
        self.text = text
        self.textColor = textColor
        self.font = font
        self.textAlignment = textAlignment
        self.backgroundColor = backgroundColor
        self.emphasisRangeArray = emphasisRangeArray
        self.emphasisColor = emphasisColor
        self.emphasisFont = emphasisFont
    }
}
