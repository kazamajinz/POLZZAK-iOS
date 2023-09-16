//
//  CouponHeaderView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/01.
//

import UIKit
import SnapKit

final class CouponHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "CouponHeaderView"
    
    private let nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.setStackView(axis: .horizontal, spacing: 8)
        stackView.alignment = .center
        return stackView
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.setLabel(text: "To", textColor: .blue500, font: .subtitle16Bd)
        return label
    }()
    
    private let memberTypeLabel = MemberTypeLabel()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .gray800, font: .subtitle18Sbd)
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

extension CouponHeaderView {
    private func setUI() {
        [headerLabel, memberTypeLabel, nickNameLabel].forEach {
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
            headerLabel.text = "From"
            memberTypeLabel.text = family.memberType.detail
        } else {
            nameStackView.removeArrangedSubview(self.memberTypeLabel)
            memberTypeLabel.removeFromSuperview()
        }
        nickNameLabel.text = family.nickname
    }
}
