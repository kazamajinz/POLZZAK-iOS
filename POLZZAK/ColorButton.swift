//
//  ColorButton.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/20.
//

import UIKit

final class ColorButton: UIButton {
    
    init(frame: CGRect = .zero, buttonStyle: ButtonStyle? = nil) {
        super.init(frame: .zero)
        
        if let style = buttonStyle {
            configure(style: style)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(style: ButtonStyle) {
        setTitleColor(style.textColor, for: .normal)
        titleLabel?.font = style.font
        backgroundColor = style.backgroundColor
        layer.borderColor = style.borderColor
        layer.cornerRadius = style.cornerRadius
        layer.borderWidth = style.borderWidth
        layer.masksToBounds = true
    }
}
