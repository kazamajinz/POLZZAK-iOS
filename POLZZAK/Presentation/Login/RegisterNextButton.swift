//
//  RegisterNextButton.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/29.
//

import UIKit

import SnapKit

final class RegisterNextButton: UIButton {
    private let titleAttrs = AttributeContainer([
        .font: UIFont.subtitle3,
        .foregroundColor: UIColor.white,
    ])
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("다음", attributes: titleAttrs)
        configuration = config
        configurationUpdateHandler = { button in
            button.isHighlighted = false
            switch button.state {
            case .disabled:
                button.backgroundColor = .blue200
            default:
                button.backgroundColor = .blue500
            }
        }
        layer.cornerRadius = 8
        tintColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(text: String) {
        configuration?.attributedTitle = AttributedString(text, attributes: titleAttrs)
    }
}
