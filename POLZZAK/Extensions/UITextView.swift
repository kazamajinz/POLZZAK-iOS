//
//  UITextView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/06.
//

import UIKit

extension UITextView {
    func setTextView(text: String = "", textColor: UIColor, font: UIFont, textAlignment: NSTextAlignment = .natural, backgroundColor: UIColor = .clear) {
        self.text = text
        self.textColor = textColor
        self.font = font
        self.textAlignment = textAlignment
        self.backgroundColor = backgroundColor
    }
}
