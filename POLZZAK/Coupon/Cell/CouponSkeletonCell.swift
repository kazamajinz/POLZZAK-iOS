//
//  CouponSkeletonCell.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/11.
//

import UIKit
import SnapKit
import SkeletonView

final class CouponSkeletonCell: UICollectionViewCell {
    static let reuseIdentifier = "CouponSkeletonCell"
    
    private let skeletonView: UIView = {
        let view = UIView()
        view.skeletonCornerRadius = 8
        view.isSkeletonable = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CouponSkeletonCell {
    private func setUI() {
        isSkeletonable = true

        contentView.addSubview(skeletonView)
        
        skeletonView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

