//
//  InprogressCouponCell.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/02.
//

import UIKit
import SnapKit

final class InprogressCouponCell: UICollectionViewCell {
    enum Constants {
        static let deviceWidth = UIApplication.shared.width
        static let circleViewWidth = (deviceWidth - 52) * 26.0 / 323.0
        static let ddayPadding = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        static let rewardRequestButtonText = "선물 조르기"
        static let rewardConfirmButtonText = "선물 받기 완료"
        static let deadlineLabelText = "까지 주기로 약속했어요"
    }
    
    static let reuseIdentifier = "InprogressCouponCell"
    
    private let contentSubView: UIView = {
        let view = UIView()
        view.addCornerRadious(cornerRadius: 10)
        return view
    }()
    
    private let ddayLabel: PaddedLabel = {
        let label = PaddedLabel(padding: Constants.ddayPadding)
        label.setLabel(textColor: .blue500, font: .caption12Bd, backgroundColor: .blue150)
        label.addCornerRadious(cornerRadius: 4)
        return label
    }()
    
    private let rewardNameTextView: UITextView = {
        let textView = UITextView()
        textView.setTextView(textColor: .black, font: .subtitle16Sbd)
        return textView
    }()
    
    private let deadlineLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .gray700, font: .caption12Md)
        label.isHidden = true
        return label
    }()
    
    private let rewardButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.setStackView(axis: .horizontal, spacing: 6)
        stackView.distribution = .fillEqually
        stackView.isHidden = true
        return stackView
    }()
    
    private let rewardRequestButton: UIButton = {
        let button = UIButton()
        button.setTitleLabel(title: Constants.rewardRequestButtonText, color: .white, font: .caption12Md, backgroundColor: .blue500)
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let rewardConfirmButton: UIButton = {
        let button = UIButton()
        button.setTitleLabel(title: Constants.rewardConfirmButtonText, color: .blue600, font: .caption12Md)
        button.addBorder(cornerRadius: 5, borderWidth: 1, borderColor: .blue150)
        return button
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
    
    private let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue400
        return view
    }()
    
    private let barcodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .barcode
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        circleView.layer.cornerRadius = Constants.circleViewWidth / 2
    }
}

extension InprogressCouponCell {
    private func setUI() {
        contentView.addSubview(contentSubView)
        
        contentSubView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        [ddayLabel, rewardNameTextView, deadlineLabel, rewardButtonStackView].forEach {
            leadView.addSubview($0)
        }
        
        [trailView, leadView, circleView, barcodeImageView].forEach {
            contentSubView.addSubview($0)
        }
        
        leadView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(contentView.frame.width * 235 / 323)
        }
        
        trailView.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.width.equalTo(Constants.deviceWidth / 2)
        }
        
        ddayLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
        }
        
        rewardNameTextView.snp.makeConstraints {
            $0.top.equalTo(ddayLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(rewardButtonStackView).inset(8)
        }
        
        deadlineLabel.snp.makeConstraints {
            $0.top.equalTo(rewardNameTextView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(24)
        }
        
        [rewardRequestButton, rewardConfirmButton].forEach {
            rewardButtonStackView.addArrangedSubview($0)
        }
        
        rewardButtonStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(24)
        }
        
        circleView.snp.makeConstraints {
            $0.trailing.equalTo(leadView.snp.trailing).offset(Constants.circleViewWidth / 2)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(Constants.circleViewWidth)
        }
        
        barcodeImageView.snp.makeConstraints {
            $0.leading.equalTo(leadView.snp.trailing).offset(17.28)
            $0.trailing.equalToSuperview().inset(15.72)
            $0.bottom.equalToSuperview().inset(27)
        }
    }
    
    func configure(with couponData: Coupon, userType: UserType) {
        ddayLabel.text = couponData.rewardDate.remainingDays()
        rewardNameTextView.text = couponData.reward
        if userType == .parent {
            deadlineLabel.text = "\(couponData.rewardDate.shortDateFormat())" + Constants.deadlineLabelText
            let emphasisRange = [NSRange(location: 0, length: 8)]
            deadlineLabel.setEmphasisRanges(emphasisRange, color: .blue500, font: .caption12Md)
            deadlineLabel.isHidden = false
            rewardButtonStackView.isHidden = true
        } else {
            deadlineLabel.isHidden = true
            rewardButtonStackView.isHidden = false
        }
    }
}
