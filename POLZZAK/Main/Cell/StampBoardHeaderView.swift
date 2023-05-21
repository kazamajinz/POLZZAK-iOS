//
//  StampBoardCollectionHeaderView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/05/18.
//

import UIKit
import SnapKit

class StampBoardHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "StampBoardHeaderView"
    
    //MARK: - nameStackView UI
    private let nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .center
        return stackView
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .gray800, font: .subtitle1)
        return label
    }()
    
    private let nickNameSubLabel: UILabel = {
        let label = UILabel()
        label.setLabel(text: "님과 함께해요", textColor: .gray600, font: .subtitle6)
        return label
    }()
    
    //MARK: - countStackView UI
    private let countStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .center
        return stackView
    }()
    
    private let currentCountLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .gray700, font: .body3)
        return label
    }()
    
    private let perLabel: UILabel = {
        let label = UILabel()
        label.setLabel(text: "/", textColor: .gray500, font: .body3)
        return label
    }()
    
    private let totalCountLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .gray500, font: .body3)
        return label
    }()
}

extension StampBoardHeaderView {
    private func setUI() {
        [currentCountLabel, perLabel, totalCountLabel].forEach {
            countStackView.addArrangedSubview($0)
        }
        
        [nickNameLabel, nickNameSubLabel].forEach {
            nameStackView.addArrangedSubview($0)
        }
        
        [nameStackView, countStackView].forEach {
            addSubview($0)
        }
        
        nameStackView.snp.makeConstraints {
            $0.top.equalTo(2)
            $0.leading.equalTo(26)
            $0.bottom.equalToSuperview()
        }
        
        countStackView.snp.makeConstraints {
            $0.top.equalTo(2)
            $0.trailing.equalTo(-26)
            $0.bottom.equalToSuperview()
        }
    }
    
    func configure(nickName: String, currentCount: Int, totalCount: Int) {
        setUI()
        nickNameLabel.text = nickName
        currentCountLabel.text = "\(currentCount)"
        totalCountLabel.text = "\(totalCount)"
    }
}
