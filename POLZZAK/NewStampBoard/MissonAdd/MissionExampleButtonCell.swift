//
//  MissionExampleButtonCell.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/09/16.
//

import UIKit

import SnapKit

class MissionExampleButtonCell: UICollectionViewCell {
    static let reuseIdentifier = "MissionExampleButtonCell"
    
    private let missonExampleButton: UIButton = {
        let button = UIButton(type: .custom)
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "misson_list_image")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 24)
        config.attributedTitle = AttributedString("미션 예시", attributes: .init([
            .font: UIFont.subtitle16Sbd,
            .foregroundColor: UIColor.white
        ]))
        button.configuration = config
        button.backgroundColor = .gray400
        button.layer.cornerRadius = 8
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MissionExampleButtonCell {
    private func configureView() {
        
    }
    
    private func configureLayout() {
        contentView.addSubview(missonExampleButton)
        
        missonExampleButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
