//
//  BaseFilterView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/28.
//

import UIKit
import SnapKit

class BaseFilterView: UIView, Filterable {
    let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    let filterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    let sectionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .center
        stackView.isHidden = true
        return stackView
    }()
    
    let memberTypeLabel = MemberTypeLabel()
    
    let nickNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray800
        label.font = .subtitle18Sbd
        return label
    }()
    
    let filterLabel: UILabel = {
        let label = UILabel()
        label.text = "전체"
        label.textColor = .gray800
        label.font = .title22Bd
        label.textAlignment = .left
        return label
    }()
    
    let filterImageView: UIButton = {
        let imageView = UIButton()
        imageView.setImage(.filterButton, for: .normal)
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonSetup() {
        addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(21)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        contentView.addSubview(filterStackView)
        
        [filterLabel, sectionStackView, filterImageView].forEach {
            filterStackView.addArrangedSubview($0)
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
}

