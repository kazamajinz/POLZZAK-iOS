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
        stackView.spacing = 6
        stackView.alignment = .center
        return stackView
    }()
    
    private let memberTypeLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor:.gray700, font: .body2, textAlignment: .center)
        return label
    }()
    
    private let nickNameLabelView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
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
        label.setLabel(text: "1", textColor: .gray700, font: .body3)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        for subView in nameStackView.arrangedSubviews {
            subView.removeFromSuperview()
        }
    }
}

extension StampBoardHeaderView {
    private func setUI() {
        [currentCountLabel, perLabel, totalCountLabel].forEach {
            countStackView.addArrangedSubview($0)
        }
        
        [nickNameLabelView].forEach {
            nameStackView.addArrangedSubview($0)
        }
        
        [nickNameLabel, nickNameSubLabel].forEach {
            nickNameLabelView.addArrangedSubview($0)
        }
        
        [nameStackView, countStackView].forEach {
            addSubview($0)
        }
        
        nameStackView.snp.makeConstraints {
            $0.top.equalTo(2)
            $0.leading.equalTo(7.5)
            $0.bottom.equalToSuperview()
        }
        
        countStackView.snp.makeConstraints {
            $0.top.equalTo(2)
            $0.trailing.equalTo(-13.93)
            $0.bottom.equalToSuperview()
        }
    }
    
    func configure(memberType: String, nickName: String, totalCount: Int) {
        setUI()
        let view = MemberTypeView(with: memberType)
        self.nameStackView.insertArrangedSubview(view, at: 0)
        nickNameLabel.text = nickName
        totalCountLabel.text = "\(totalCount)"
        countStackView.isHidden = totalCount == 0
    }
    
    func updateCurrentCount(with count: Int) {
        guard let totalCountText = totalCountLabel.text else { return }
        guard let totalCount = Int(totalCountText) else { return }
        
        if count <= totalCount {
            currentCountLabel.text = "\(count)"
        }
    }
}
