//
//  CompletedCouponCell.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/06.
//

import UIKit
import SnapKit

final class CompletedCouponCell: UICollectionViewCell {
    enum Constants {
        static let deviceWidth = UIApplication.shared.width
        static let leadViewWidthRatio = 235.0 / 323.0
    }
    
    static let reuseIdentifier = "CompletedCouponCell"
    
    private let contentSubView: UIView = {
        let view = UIView()
        view.addBorder(cornerRadius: 10)
        return view
    }()
    
    private let rewardNameTextView: UITextView = {
        let textView = UITextView()
        textView.setTextView(textColor: .black, font: .subtitle16Sbd)
        return textView
    }()
    
    private let leadView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addBorder(
            corners: [.layerMinXMinYCorner, .layerMinXMaxYCorner],
            cornerRadius: 10,
            borderWidth: 1,
            borderColor: .gray200
        )
        return view
    }()
    
    private let trailView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue400
        return view
    }()
    
    private let barcodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .barcode
        return imageView
    }()
    
    private let rewardLabelImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .rewardCompleted
        return imageView
    }()
    
    private let blindView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.4)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

extension CompletedCouponCell {
    private func setUI() {
        contentView.addSubview(contentSubView)
        
        contentSubView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        leadView.addSubview(rewardNameTextView)
        
        [trailView, leadView, barcodeImageView, blindView, rewardLabelImageView].forEach {
            contentSubView.addSubview($0)
        }
        
        leadView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(contentView.frame.width * Constants.leadViewWidthRatio)
        }
        
        trailView.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.width.equalTo(Constants.deviceWidth / 2)
        }
        
        rewardNameTextView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        
        barcodeImageView.snp.makeConstraints {
            $0.leading.equalTo(leadView.snp.trailing).offset(17.28)
            $0.trailing.equalToSuperview().inset(15.72)
            $0.bottom.equalToSuperview().inset(27)
        }
        
        blindView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        rewardLabelImageView.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview().inset(16)
        }
    }
    
    func configure(with couponData: Coupon) {
        rewardNameTextView.text = couponData.reward
    }
}
