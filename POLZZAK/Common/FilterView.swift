//
//  FilterView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/06.
//

import UIKit
import SnapKit
import SkeletonView

final class FilterView: UIView {
    private let contentView: UIView = {
        let view = UIView()
        view.skeletonCornerRadius = 8
        view.isSkeletonable = true
        return view
    }()
    
    let filterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    private let nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.isHidden = true
        return stackView
    }()
    
    private let sectionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .center
        stackView.isHidden = true
        return stackView
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.setLabel(text: "To", textColor: .blue500, font: .subtitle16Bd)
        label.isHidden = true
        return label
    }()
    
    private let memberTypeLabel: MemberTypeLabel = {
        let memberTypeLabel = MemberTypeLabel()
        memberTypeLabel.isHidden = true
        return memberTypeLabel
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .gray800, font: .subtitle18Sbd)
        label.isHidden = true
        return label
    }()
    
    private let filterLabel: UILabel = {
        let label = UILabel()
        label.setLabel(text: "전체", textColor: .gray800, font: .title4, textAlignment: .left)
        label.isHidden = true
        return label
    }()
    
    private let filterImageView: UIButton = {
        let imageView = UIButton()
        imageView.setImage(.filterButton, for: .normal)
        imageView.isHidden = true
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        isSkeletonable = true
        
        addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(21)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        contentView.addSubview(filterStackView)
        
        [filterLabel, nameStackView, filterImageView].forEach {
            filterStackView.addArrangedSubview($0)
        }
        
        [headerLabel, sectionStackView].forEach {
            nameStackView.addArrangedSubview($0)
        }
        
        [memberTypeLabel, nickNameLabel].forEach {
            sectionStackView.addArrangedSubview($0)
        }
        
        filterStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview().priority(750)
        }
    }
    
    func handleAllFilterButtonTap() {
        headerLabel.isHidden = true
        nameStackView.isHidden = true
        nickNameLabel.isHidden = true
        sectionStackView.isHidden = true
        memberTypeLabel.isHidden = true
        filterImageView.isHidden = false
        filterLabel.isHidden = false
    }
    
    func handleChildSectionFilterButtonTap(with family: FamilyMember) {
        nickNameLabel.text = family.nickName
        memberTypeLabel.text = family.memberType.detail
        headerLabel.isHidden = false
        nameStackView.isHidden = false
        nickNameLabel.isHidden = false
        sectionStackView.isHidden = false
        memberTypeLabel.isHidden = false
        filterLabel.isHidden = true
    }
    
    func handleParentSectionFilterButtonTap(with family: FamilyMember) {
        nickNameLabel.text = family.nickName
        headerLabel.isHidden = false
        nameStackView.isHidden = false
        nickNameLabel.isHidden = false
        sectionStackView.isHidden = false
        memberTypeLabel.isHidden = true
        filterLabel.isHidden = true
    }
}
