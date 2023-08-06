//
//  CouponEmptyCell.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/02.
//

import UIKit
import SnapKit

final class CouponEmptyCell: UICollectionViewCell {
    static let reuseIdentifier = "CouponEmptyCell"
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.setLabel(text: "쿠폰이 없어요", textColor: .gray700, font: .body14Md, textAlignment: .center)
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

extension CouponEmptyCell {
    private func setUI() {
        backgroundColor = .white
        addDashedBorder(borderColor: .gray300, spacing: 3, cornerRadius: 8)
        
        contentView.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }
}

