//
//  InprogressStampBoardCell.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/05/18.
//

import UIKit
import SnapKit

class InprogressStampBoardCell: UICollectionViewCell {
    static let reuseIdentifier = "InprogressStampBoardCell"
    
    //MARK: - Stamp Top UI
    private let stampTopView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let stampNameLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .gray700, font: .title20Bd)
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
        label.setLabel(textColor: .blue400, font: .title24Sbd)
        return label
    }()
    
    private let perLabel: UILabel = {
        let label = UILabel()
        label.setLabel(text: "/" ,textColor: .gray400, font: .subtitle16Sbd)
        return label
    }()
    
    private let totalCountLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .gray400, font: .subtitle16Sbd)
        return label
    }()
    
    private let stampGraphView: StampGraphView = {
        let stampGraphView = StampGraphView()
        return stampGraphView
    }()
    
    private let stampRequestView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let stampRequestImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .raisingOneHandCharacter
        return imageView
    }()
    
    private let stampRequestLabelView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue100
        view.addBorder(cornerRadius: 10.5)
        return view
    }()
    
    private let stampRequestLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .blue600, font: .caption12Sbd, textAlignment: .center)
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
    
    private let rewardLabel: UILabel = {
        let label = UILabel()
        label.addBorder(cornerRadius: 4)
        label.setLabel(text: "보상", textColor: .white, font: .caption12Sbd, textAlignment: .center, backgroundColor: .blue400)
        return label
    }()
    
    private let rewardTitleLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .gray700, font: .body14Sbd)
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

extension InprogressStampBoardCell {
    func configure(with info: StampBoardSummary) {
        stampNameLabel.text = info.name
        currentCountLabel.text = "\(info.currentStampCount)"
        totalCountLabel.text = "\(info.goalStampCount)"
        stampRequestLabel.text = "도장 요청 \(info.missionRequestCount)개"
        rewardTitleLabel.text = info.reward
        
        let graphValue = CGFloat(info.currentStampCount) / CGFloat(info.goalStampCount)
        DispatchQueue.main.async {
            self.stampGraphView.startAnimation(withValue: graphValue)
        }
    }
    
    private func setUI() {
        backgroundColor = .white
        addBorder(cornerRadius: 8, borderWidth: 1, borderColor: .gray300)
        
        //MARK: - Stamp Top UI
        [stampNameLabel, stampNameButton].forEach {
            stampTopView.addArrangedSubview($0)
        }
        
        stampNameButton.snp.makeConstraints {
            $0.width.equalTo(stampNameButton.snp.height)
        }
        
        //MARK: - Stamp Bottom UI
        [rewardLabel, rewardTitleLabel].forEach {
            stampBottomView.addArrangedSubview($0)
        }
        
        rewardLabel.snp.makeConstraints {
            $0.width.equalTo(rewardLabel.snp.height).multipliedBy(33.0/25.0)
        }
        
        //MARK: - Main UI
        [stampTopView, stampMiddleView, stampBottomView].forEach {
            addSubview($0)
        }
        
        stampTopView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(stampTopView.snp.width).multipliedBy(28.0/283.0)
        }
        
        stampMiddleView.snp.makeConstraints {
            $0.top.equalTo(stampTopView.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview().inset(41.5)
            $0.bottom.equalTo(stampBottomView.snp.top).inset(8)
        }
        
        stampBottomView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(stampBottomView.snp.width).multipliedBy(25.0/283.0)
        }
         
        //MARK: - Stamp Middle UI
        [stampGraphView, stampRequestView].forEach {
            stampMiddleView.addSubview($0)
        }
        
        stampGraphView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stampRequestView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        [currentCountLabel, perLabel, totalCountLabel].forEach {
            countStackView.addArrangedSubview($0)
        }
        
        [countStackView, stampRequestImageView, stampRequestLabelView].forEach {
            stampRequestView.addSubview($0)
        }
        
        countStackView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.height.equalTo(stampGraphView.snp.height).multipliedBy(34.0 / 240.0)
        }
        
        stampRequestImageView.snp.makeConstraints {
            $0.top.equalTo(countStackView.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview()
            $0.height.width.equalTo(stampGraphView.snp.height).multipliedBy(86.0 / 240.0)
        }
        
        stampRequestLabelView.snp.makeConstraints {
            $0.top.equalTo(stampRequestImageView.snp.bottom).offset(2)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(stampGraphView.snp.height).multipliedBy(21.0 / 240.0)
        }
        
        stampRequestLabelView.addSubview(stampRequestLabel)
        
        stampRequestLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(2)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
    }
}
