//
//  UITextView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/06.
//

import UIKit

extension UITextView {
    func setTextView(text: String? = nil, textColor: UIColor, font: UIFont, textAlignment: NSTextAlignment = .natural, backgroundColor: UIColor = .clear) {
        if let text = text {
            self.text = text
        }
        self.textColor = textColor
        self.font = font
        self.textAlignment = textAlignment
        self.backgroundColor = backgroundColor
        self.isUserInteractionEnabled = false
    }
}
