//
//  CompletedStampBoardCell.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/05/24.
//

import UIKit
import SnapKit

final class CompletedStampBoardCell: UICollectionViewCell {
    static let reuseIdentifier = "CompletedStampBoardCell"
    
    private let stampNameLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .blindTextColor, font: .title24Sbd)
        return label
    }()
    
    private let stampRewardView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        return stackView
    }()
    
    private let rewardLabelView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue200.withAlphaComponent(0.6)
        view.addBorder(cornerRadius: 4)
        return view
    }()
    
    private let rewardLabel: UILabel = {
        let label = UILabel()
        
        label.setLabel(text: "보상", textColor: .blue600, font: .caption12Sbd, textAlignment: .center)
        return label
    }()
    
    private let rewardTitleLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .blindTextColor, font: .body14Sbd)
        return label
    }()
    
    private let couponLabelImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .couponCompleted
        return imageView
    }()
    
    private let blindView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        view.addBorder(cornerRadius: 8, borderWidth: 1, borderColor: .gray300)
        return view
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
        
        addBorder(cornerRadius: 8, borderWidth: 1, borderColor: .gray300)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        layer.cornerRadius = 0
        layer.maskedCorners = []
    }
}

extension CompletedStampBoardCell {
    func configure(with info: StampBoardSummary) {
        stampNameLabel.text = info.name
        rewardTitleLabel.text = info.reward
    }
    
    private func setUI() {
        [rewardLabelView, rewardTitleLabel].forEach {
            stampRewardView.addArrangedSubview($0)
        }
        
        rewardLabelView.snp.makeConstraints {
            $0.width.equalTo(rewardLabelView.snp.height).multipliedBy(33.0/25.0)
        }
        
        [stampNameLabel, stampRewardView, blindView, couponLabelImageView].forEach {
            addSubview($0)
        }
        
        stampNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        rewardLabelView.addSubview(rewardLabel)
        
        rewardLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(4)
            $0.leading.trailing.equalToSuperview().inset(6)
        }
        
        stampRewardView.snp.makeConstraints {
            $0.top.equalTo(stampNameLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        blindView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        couponLabelImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(11)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
}
 
