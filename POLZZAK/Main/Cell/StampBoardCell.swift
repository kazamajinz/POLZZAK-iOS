//
//  StampBoardCell.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/05/18.
//

import UIKit
import SnapKit

class StampBoardCell: UICollectionViewCell {
    static let reuseIdentifier = "StampBoardCell"
    
    //MARK: - Stamp Top UI
    private let stampTopView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let stampNameLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .gray700, font: .title3)
        return label
    }()
    
    private let stampNameButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .rightArrowButton
        return imageView
    }()
    
    //MARK: - Stamp Middle UI
    private let stampMiddleView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let countStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .bottom
        return stackView
    }()
    
    private let currentCountLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .blue400, font: .title1)
        return label
    }()
    
    private let perLabel: UILabel = {
        let label = UILabel()
        label.setLabel(text: "/" ,textColor: .gray400, font: .subtitle3)
        return label
    }()
    
    private let totalCountLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .gray400, font: .subtitle3)
        return label
    }()
    
    private let stampGraphView: StampGraphView = {
        let stampGraphView = StampGraphView()
        return stampGraphView
    }()
    
    private let stampRequestImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .stampRequestCharacter
        return imageView
    }()
    
    private let stampLabelView: UIView = {
        let view = UIView()
        view.setCustomView(radius: 8.5, color: .blue100)
        return view
    }()
    
    private let stampRequestLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .blue600, font: .caption1, textAlignment: .center)
        return label
    }()
    
    //MARK: - Stamp Bottom UI
    private let stampBottomView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        return stackView
    }()
    
    private let stampRewardView: UIView = {
        let view = UIView()
        view.setCustomView(radius: 4, color: .blue400)
        return view
    }()
    
    private let rewardLabel: UILabel = {
        let label = UILabel()
        label.setLabel(text: "보상", textColor: .white, font: .caption1)
        return label
    }()
    
    private let rewardTitleLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .gray700, font: .body2)
        return label
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
        stampGraphView.reset()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension StampBoardCell {
    func configure(with info: StampBoardSummary) {
        stampNameLabel.text = info.name
        currentCountLabel.text = "\(info.currentStampCount)"
        totalCountLabel.text = "\(info.goalStampCount)"
        stampRequestLabel.text = "도장 요청 \(info.missionCompleteCount)개"
        rewardTitleLabel.text = info.reward
        
        let graphValue = CGFloat(info.currentStampCount) / CGFloat(info.goalStampCount)
        DispatchQueue.main.async {
            self.stampGraphView.startAnimation(withValue: graphValue)
        }
        
    }
    
    private func setUI() {
        backgroundColor = .white
        
        //MARK: - Stamp Top UI
        [stampNameLabel, stampNameButton].forEach {
            stampTopView.addArrangedSubview($0)
        }
        
        stampNameButton.snp.makeConstraints {
            $0.width.equalTo(stampNameButton.snp.height)
        }
        
        //MARK: - Stamp Bottom UI
        [stampRewardView, rewardTitleLabel].forEach {
            stampBottomView.addArrangedSubview($0)
        }
        
        stampRewardView.addSubview(rewardLabel)
        
        stampRewardView.snp.makeConstraints {
            $0.width.equalTo(stampRewardView.snp.height).multipliedBy(33.0/25.0)
        }
        
        rewardLabel.snp.makeConstraints {
            $0.top.equalTo(4)
            $0.leading.equalTo(6)
            $0.trailing.equalTo(-6)
            $0.bottom.equalTo(-4)
        }
        
        //MARK: - Main UI
        [stampTopView, stampMiddleView, stampBottomView].forEach {
            addSubview($0)
        }
        
        stampTopView.snp.makeConstraints {
            $0.top.equalTo(20)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.height.equalTo(stampTopView.snp.width).multipliedBy(28.0/283.0)
        }
        
        stampMiddleView.snp.makeConstraints {
            $0.top.equalTo(stampTopView.snp.bottom).offset(36)
            $0.leading.equalTo(41.5)
            $0.trailing.equalTo(-41.5)
            $0.width.equalTo(stampMiddleView.snp.height)
        }
        
        stampBottomView.snp.makeConstraints {
            $0.top.equalTo(stampMiddleView.snp.bottom).offset(8)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.bottom.equalTo(-20)
            $0.height.equalTo(stampBottomView.snp.width).multipliedBy(25.0/283.0)
        }
        
        //MARK: - Stamp Middle UI
        [stampGraphView].forEach {
            stampMiddleView.addSubview($0)
        }
        
        stampGraphView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        [currentCountLabel, perLabel, totalCountLabel].forEach {
            countStackView.addArrangedSubview($0)
        }
        
        [countStackView, stampRequestImageView, stampLabelView].forEach {
            stampGraphView.addSubview($0)
        }
        
        countStackView.snp.makeConstraints {
            $0.top.equalTo(75)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(stampRequestImageView).multipliedBy(34.0/86.0)
        }
        
        stampRequestImageView.snp.makeConstraints {
            $0.top.equalTo(countStackView.snp.bottom).offset(4)
            $0.leading.equalTo(77)
            $0.trailing.equalTo(-77)
            $0.height.width.equalTo(stampRequestImageView.snp.width).multipliedBy(109.0/86.0)
        }
        
        stampLabelView.snp.makeConstraints {
            $0.top.equalTo(stampRequestImageView.snp.bottom).offset(2)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(stampLabelView.snp.width).multipliedBy(21.0/86.0)
        }
        
        stampLabelView.addSubview(stampRequestLabel)
        
        stampRequestLabel.snp.makeConstraints {
            $0.top.equalTo(2)
            $0.leading.equalTo(10)
            $0.trailing.equalTo(-10)
            $0.bottom.equalTo(-2)
        }
    }
}
