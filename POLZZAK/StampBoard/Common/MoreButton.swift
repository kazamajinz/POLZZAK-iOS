//
//  MoreButton.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/22.
//

import UIKit

class MoreButton: UIButton {
    convenience init(title: String, titleWhenSelected: String? = nil) {
        self.init(type: .system)
        var config = UIButton.Configuration.plain()
        var titleContainer = AttributeContainer()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 10)
        titleContainer.font = .body4
        titleContainer.foregroundColor = .gray500
        config.preferredSymbolConfigurationForImage = imageConfig
        config.imagePlacement = .trailing
        config.imagePadding = 6
        config.background.cornerRadius = 0
        config.background.backgroundColor = .white
        config.cornerStyle = .fixed
        configuration = config
        configurationUpdateHandler = { button in
            switch button.state {
            case .selected:
                // TODO: chevron.up이미지 폴짝 이미지로 바꾸기
                button.configuration?.image = UIImage(systemName: "chevron.up")?.withTintColor(.gray500, renderingMode: .alwaysOriginal)
                button.configuration?.attributedTitle = AttributedString(titleWhenSelected ?? title, attributes: titleContainer)
            case .normal:
                // TODO: chevron.down이미지 폴짝 이미지로 바꾸기
                button.configuration?.image = UIImage(systemName: "chevron.down")?.withTintColor(.gray500, renderingMode: .alwaysOriginal)
                button.configuration?.attributedTitle = AttributedString(title, attributes: titleContainer)
            default:
                return
            }
        }
    }
}
