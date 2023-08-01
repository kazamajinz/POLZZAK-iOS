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
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .blue500, font: .subtitle16Bd)
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
        headerLabel.text = type == .parent ? "To" : "From"
        memberTypeLabel.text = family.memberType.detail
        nickNameLabel.text = family.nickName
    }
}
