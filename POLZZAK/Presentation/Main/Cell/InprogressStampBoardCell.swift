//
//  InprogressStampBoardCell.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/05/18.
//

import UIKit
import SnapKit

final class InprogressStampBoardCell: UICollectionViewCell {
    enum Constants {
        static let reuseIdentifier = "InprogressStampBoardCell"
        static let stampRequestLabelInsets = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10)
        static let gradationLabelInsets = UIEdgeInsets(top: 4, left: 16, bottom: 11, right: 16)
        static let deviceWidth = UIApplication.shared.width
        static let imageViewWidth = deviceWidth * 86.0 / 375.0
        static let imageViewHeight = deviceWidth * 86.0 / 375.0
        static let countLabelMultiply = 34.0 / 52.0
        static let gradationViewWidth = deviceWidth * 150.0 / 375.0
    }
    
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
    private let stampMiddleView = UIView()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .gray400, font: .subtitle16Sbd, textAlignment: .center)
        return label
    }()
    
    private let stampGraphView: StampGraphView = {
        let stampGraphView = StampGraphView()
        return stampGraphView
    }()
    
    private let stampRequestView = UIView()
    
    private let stampProgressStatusView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    private let stampCompletedStatusView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    private let stampProgressRequestImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .raisingOneHandCharacter
        return imageView
    }()
    
    private let stampProgressRequestLabel: PaddedLabel = {
        let label = PaddedLabel(padding: Constants.stampRequestLabelInsets)
        label.setLabel(textColor: .blue600, font: .caption12Sbd, textAlignment: .center, backgroundColor: .blue100)
        label.addBorder(cornerRadius: 10.5)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    private let stampCompletedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .raisingTwoHandCharacter
        return imageView
    }()
    
    private let gradationView = MessageView()
    
    //MARK: - Stamp Bottom UI
    private let stampBottomView: UIStackView = {
        let stackView = UIStackView()
        stackView.setStackView(axis: .horizontal, spacing: 8)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addBorder(cornerRadius: 8, borderWidth: 1, borderColor: .gray300)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        stampGraphView.reset()
        layer.cornerRadius = 0
        layer.maskedCorners = []
    }
}

extension InprogressStampBoardCell {
    func configure(with info: StampBoardSummary) {
        stampNameLabel.text = info.name
        rewardTitleLabel.text = info.reward
        
        switch info.status {
        case .progress:
            stampProgressRequestLabel.text = "도장 요청 \(info.missionRequestCount)개"
            stampProgressStatusView.isHidden = false
            stampCompletedStatusView.isHidden = true
        case .completed:
            stampProgressStatusView.isHidden = true
            stampCompletedStatusView.isHidden = false
            
            //TODO: - DTO에서 Model로 변환할때 UserType을 단순하게 부모인지 아이인지 변환하고 UserInfo에서 사용하는 Model에 userType을 추가했으면 좋겠음.
            let userInfo = UserInfoManager.readUserInfo()
            gradationView.type = userInfo?.memberType.detail == "아이" ? .request : .completed
        case .issuedCoupon:
            stampProgressStatusView.isHidden = true
            stampCompletedStatusView.isHidden = false
            gradationView.type = .issuedCoupon
        default:
            return
        }
        
        countLabel.text = "\(info.currentStampCount)" + "/" + "\(info.goalStampCount)"
        let emphasisRange = [NSRange(location: 0, length: String(info.currentStampCount).count)]
        countLabel.setEmphasisRanges(emphasisRange, color: .blue400, font: .title24Sbd)
        
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
        }
        
        stampBottomView.snp.makeConstraints {
            $0.top.equalTo(stampMiddleView.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(stampBottomView.snp.width).multipliedBy(25.0/283.0)
        }
         
        //MARK: - Stamp Middle UI
        [stampProgressRequestImageView, stampProgressRequestLabel].forEach {
            stampProgressStatusView.addSubview($0)
        }
        
        [stampCompletedImageView, gradationView].forEach {
            stampCompletedStatusView.addSubview($0)
        }
        
        [countLabel, stampProgressStatusView, stampCompletedStatusView].forEach {
            stampRequestView.addSubview($0)
        }
        
        [stampGraphView, stampRequestView].forEach {
            stampMiddleView.addSubview($0)
        }
        
        stampGraphView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stampRequestView.snp.makeConstraints {
            $0.top.equalTo(stampGraphView.snp.top).offset(55)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(stampGraphView.snp.bottom)
        }
        
        countLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        stampProgressStatusView.snp.makeConstraints {
            $0.top.equalTo(countLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(77)
            $0.bottom.equalToSuperview()
        }
        
        stampCompletedStatusView.snp.makeConstraints {
            $0.top.equalTo(countLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(77)
            $0.bottom.equalToSuperview()
        }
        
        stampProgressRequestImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(stampProgressRequestImageView.snp.height)
        }
        
        stampProgressRequestLabel.snp.makeConstraints {
            $0.top.equalTo(stampProgressRequestImageView.snp.bottom).offset(2)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(38)
        }
        
        gradationView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        stampCompletedImageView.snp.makeConstraints {
            $0.top.equalTo(gradationView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(stampCompletedImageView.snp.height)
            $0.bottom.equalToSuperview().inset(11)
        }
    }
}
