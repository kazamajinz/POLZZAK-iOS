//
//  CouponHeaderView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/01.
//

import UIKit
import SnapKit
import SkeletonView

final class CouponHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "CouponHeaderView"
    
    let skeletonView: UIView = {
        let view = UIView()
        view.skeletonCornerRadius = 8
        view.isSkeletonable = true
        return view
    }()
    
    private let nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.isHidden = true
        stackView.isSkeletonable = true
        return stackView
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.setLabel(text: "To", textColor: .blue500, font: .subtitle16Bd)
        label.isSkeletonable = true
        return label
    }()
    
    private let memberTypeLabel = MemberTypeLabel()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .gray800, font: .subtitle18Sbd)
        label.isSkeletonable = true
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
        isSkeletonable = true
        memberTypeLabel.isHidden = true
        
        [headerLabel, memberTypeLabel, nickNameLabel].forEach {
            nameStackView.addArrangedSubview($0)
        }
        
        [nameStackView, skeletonView].forEach {
            addSubview($0)
        }
        
        nameStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(2)
            $0.leading.equalToSuperview().inset(4.55)
            $0.bottom.equalToSuperview()
        }
        
        skeletonView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(195.0 / 323.0)
        }
    }
    
    func configure(to family: FamilyMember, type: UserType) {
        nameStackView.isHidden = false
        if type == .child {
            headerLabel.text = "From"
            memberTypeLabel.text = family.memberType.detail
        } else {
            nameStackView.removeArrangedSubview(self.memberTypeLabel)
            memberTypeLabel.removeFromSuperview()
        }
        nickNameLabel.text = family.nickName
    }
}
