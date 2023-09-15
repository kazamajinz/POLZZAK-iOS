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
        var config = UIButton.Configuration.borderedTinted()
        config.attributedTitle = AttributedString("+ 미션 추가하기", attributes: .init([
            .font: UIFont.body14Md,
            .foregroundColor: UIColor.gray400
        ]))
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
        missonExampleButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
