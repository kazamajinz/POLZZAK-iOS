//
//  UserTypeSelectButton.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/29.
//

import UIKit

class UserTypeSelectButton: UIButton {
    
    
    init(frame: CGRect = .zero, userType: UserType) {
        super.init(frame: frame)
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: userType.imageName)
        config.titleAlignment = .center
        config.titlePadding = 12
        config.imagePlacement = .bottom
        config.imagePadding = 12
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 120)
        
        let titleAttrs = AttributeContainer([
            .font: UIFont.subtitle2,
            .foregroundColor: UIColor.gray700,
        ])
        let subtitleAttrs = AttributeContainer([
            .font: UIFont.caption2,
            .foregroundColor: UIColor.gray500,
        ])
        config.attributedTitle = AttributedString(userType.title, attributes: titleAttrs)
        config.attributedSubtitle = AttributedString(userType.subtitle, attributes: subtitleAttrs)
        
        self.configuration = config
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Nested Types

extension UserTypeSelectButton {
    enum UserType {
        case child
        case parent
        
        var title: String {
            switch self {
            case .child: return Constant.Child.title
            case .parent: return Constant.Parent.title
            }
        }
        
        var subtitle: String {
            switch self {
            case .child: return Constant.Child.subtitle
            case .parent: return Constant.Parent.subtitle
            }
        }
        
        var imageName: String {
            switch self {
            case .child: return Constant.Child.imageName
            case .parent: return Constant.Parent.imageName
            }
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
