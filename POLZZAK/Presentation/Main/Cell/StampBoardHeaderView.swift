//
//  StampBoardHeaderView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/24.
//

import UIKit
import SnapKit

final class StampBoardHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "StampBoardHeaderView"
    
    private let nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.setStackView(axis: .horizontal, spacing: 8)
        stackView.alignment = .center
        return stackView
    }()
    
    private let memberTypeLabel = MemberTypeLabel()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .gray600, font: .subtitle18Rg)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StampBoardHeaderView {
    private func setUI() {
        [memberTypeLabel, nicknameLabel].forEach {
            nameStackView.addArrangedSubview($0)
        }
        
        addSubview(nameStackView)
        
        nameStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(2)
            $0.leading.equalToSuperview().inset(4.55)
            $0.bottom.equalToSuperview()
        }
    }
    
    func configure(to family: FamilyMember, type: UserType) {
        if type == .child {
            memberTypeLabel.text = family.memberType.detail
        } else {
            nameStackView.removeArrangedSubview(self.memberTypeLabel)
            memberTypeLabel.removeFromSuperview()
        }
        nicknameLabel.text = family.nickname + "님과 함께해요"
        let emphasisRange = [NSRange(location: 0, length: String(family.nickname).count)]
        nicknameLabel.setEmphasisRanges(emphasisRange, color: .gray800, font: .subtitle18Sbd)
    }
}
