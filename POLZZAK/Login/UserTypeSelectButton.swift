//
//  UserTypeSelectButton.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/29.
//

import UIKit

final class UserTypeSelectButton: UIButton {
    let userType: LoginUserType
    
    init(frame: CGRect = .zero, userType: LoginUserType) {
        self.userType = userType
        super.init(frame: frame)
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: imageName)
        config.titleAlignment = .center
        config.titlePadding = 12
        config.imagePlacement = .bottom
        config.imagePadding = 12
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 120)
        
        layer.cornerRadius = 10
        layer.borderWidth = 1
        configuration = config
        configurationUpdateHandler = { [weak self] button in
            button.isHighlighted = false
            self?.updateButtonOnState(button: button)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateButtonOnState(button: UIButton) {
        switch button.state {
        case .selected:
            button.layer.borderColor = UIColor.blue500.cgColor
            let titleAttrs = AttributeContainer([
                .font: UIFont.subtitle2,
                .foregroundColor: UIColor.blue600,
            ])
            let subtitleAttrs = AttributeContainer([
                .font: UIFont.caption2,
                .foregroundColor: UIColor.blue600,
            ])
            button.configuration?.attributedTitle = AttributedString(title, attributes: titleAttrs)
            button.configuration?.attributedSubtitle = AttributedString(subtitle, attributes: subtitleAttrs)
            button.configuration?.background.backgroundColor = .blue100
        default:
            button.layer.borderColor = UIColor.gray300.cgColor
            let titleAttrs = AttributeContainer([
                .font: UIFont.subtitle2,
                .foregroundColor: UIColor.gray700,
            ])
            let subtitleAttrs = AttributeContainer([
                .font: UIFont.caption2,
                .foregroundColor: UIColor.gray500,
            ])
            button.configuration?.attributedTitle = AttributedString(title, attributes: titleAttrs)
            button.configuration?.attributedSubtitle = AttributedString(subtitle, attributes: subtitleAttrs)
            button.configuration?.background.backgroundColor = .white
        }
    }
}

// MARK: - Computed Property & Nested Types

extension UserTypeSelectButton {
    var title: String {
        switch userType {
        case .child: return Constant.Child.title
        case .parent: return Constant.Parent.title
        }
    }
    
    var subtitle: String {
        switch userType {
        case .child: return Constant.Child.subtitle
        case .parent: return Constant.Parent.subtitle
        }
    }
    
    var imageName: String {
        switch userType {
        case .child: return Constant.Child.imageName
        case .parent: return Constant.Parent.imageName
        }
    }
    
    enum Constant {
        enum Child {
            static let title = "아이 회원"
            static let subtitle = "\"칭찬 도장을 모아서\n선물을 받고 싶어요\""
            static let imageName = "login_child_image"
        }
        
        enum Parent {
            static let title = "보호자 회원"
            static let subtitle = "\"도장판을 만들어서\n칭찬 도장을 찍어주고 싶어요\""
            static let imageName = "login_parent_image"
        }
    }
}
