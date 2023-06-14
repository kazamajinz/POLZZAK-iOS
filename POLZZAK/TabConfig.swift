//
//  TabConfig.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/13.
//

import UIKit


struct TabConfig {
    let text: String
    let textArray: [String]
    let textColor: UIColor
    let font: UIFont
    let textAlignment: NSTextAlignment
    let lineColor: UIColor
    let lineHeight: CGFloat
    let selectTextColor: UIColor
    let selectLineColor: UIColor
    let selectLineHeight: CGFloat
    
    init(
        text: String = "",
        textArray: [String] = [],
        textColor: UIColor,
        font: UIFont,
        textAlignment: NSTextAlignment = .center,
        lineColor: UIColor,
        lineHeight: CGFloat,
        selectTextColor: UIColor,
        selectLineColor: UIColor,
        selectLineHeight: CGFloat
    ) {
        self.text = text
        self.textArray = textArray
        self.textColor = textColor
        self.font = font
        self.textAlignment = textAlignment
        self.lineColor = lineColor
        self.lineHeight = lineHeight
        self.selectTextColor = selectTextColor
        self.selectLineColor = selectLineColor
        self.selectLineHeight = selectLineHeight
    }
}
