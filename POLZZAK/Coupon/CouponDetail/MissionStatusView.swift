//
//  MissionStatusView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/17.
//

import UIKit
import SnapKit
protocol MissionStatusViewDelegate: AnyObject {
    func didTapMissionHeader()
}

final class MissionStatusView: UIView {
    enum Constants {
        static let completedMissionLabel = "완료 미션"
        static let completedStampLabel = "모은 도장"
        static let durationLabel = "걸린 기간"
        static let countLabel = "개"
        static let dateLabel = "일"
    }
    
    weak var delegate: MissionStatusViewDelegate?
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.setStackView(axis: .horizontal, spacing: 40)
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    //MARK: - 완료미션
    private let completedMissionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.setStackView(axis: .vertical, spacing: 2)
        stackView.alignment = .center
        return stackView
    }()
    
    private let completedMissionHeaderView: UIStackView = {
        let stackView = UIStackView()
        stackView.setStackView(axis: .horizontal, spacing: 2)
        return stackView
    }()
    
    private let completedMissionLabel: UILabel = {
        let label = UILabel()
        label.setLabel(text: Constants.completedMissionLabel, textColor: .gray500, font: .body13Md)
        return label
    }()
    
    private let completedMissionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .chevronRightIcon
        return imageView
    }()
    
    private let completedMissionCountView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let completedMissionCountLeadingLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .blue600, font: .subtitle18Sbd)
        return label
    }()
    
    private let completedMissionCountTrailingLabel: UILabel = {
        let label = UILabel()
        label.setLabel(text: Constants.countLabel, textColor: .blue600, font: .caption12Sbd)
        return label
    }()
    
    //MARK: - 모은도장
    private let completedStampStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.setStackView(axis: .vertical, spacing: 2)
        stackView.alignment = .center
        return stackView
    }()
    
    private let completedStampLabel: UILabel = {
        let label = UILabel()
        label.setLabel(text: Constants.completedStampLabel, textColor: .gray500, font: .body13Md)
        return label
    }()
    
    private let completedStampImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .chevronRightIcon
        return imageView
    }()
    
    private let completedStampCountView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let completedStampCountLeadingLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .blue600, font: .subtitle18Sbd)
        return label
    }()
    
    private let completedStampCountTrailingLabel: UILabel = {
        let label = UILabel()
        label.setLabel(text: Constants.countLabel, textColor: .blue600, font: .caption12Sbd)
        return label
    }()
    
    //MARK: - 걸린기간
    private let durationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.setStackView(axis: .vertical, spacing: 2)
        stackView.alignment = .center
        return stackView
    }()
    
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.setLabel(text: Constants.durationLabel, textColor: .gray500, font: .body13Md)
        return label
    }()
    
    private let durationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .chevronRightIcon
        return imageView
    }()
    
    private let durationCountView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let durationCountLeadingLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .blue600, font: .subtitle18Sbd)
        return label
    }()
    
    private let durationCountTrailingLabel: UILabel = {
        let label = UILabel()
        label.setLabel(text: Constants.dateLabel, textColor: .blue600, font: .caption12Sbd)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(5.5)
            $0.bottom.equalToSuperview()
        }
        
        [completedMissionStackView, completedStampStackView, durationStackView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        setupCompletedMissionViews()
        setupCompletedStampViews()
        setupDurationViews()
    }
    
    private func setupCompletedMissionViews() {
        [completedMissionLabel, completedMissionImageView].forEach {
            completedMissionHeaderView.addArrangedSubview($0)
        }
        
        [completedMissionCountLeadingLabel, completedMissionCountTrailingLabel].forEach {
            completedMissionCountView.addSubview($0)
        }
        
        completedMissionCountLeadingLabel.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }
        
        completedMissionCountTrailingLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6)
            $0.leading.equalTo(completedMissionCountLeadingLabel.snp.trailing).offset(2)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(2)
        }
        
        [completedMissionHeaderView, completedMissionCountView].forEach {
            completedMissionStackView.addArrangedSubview($0)
        }
    }
    
    
    private func setupCompletedStampViews() {
        [completedStampCountLeadingLabel, completedStampCountTrailingLabel].forEach {
            completedStampCountView.addSubview($0)
        }
        
        completedStampCountLeadingLabel.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }
        
        completedStampCountTrailingLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6)
            $0.leading.equalTo(completedStampCountLeadingLabel.snp.trailing).offset(2)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(2)
        }
        
        [completedStampLabel, completedStampCountView].forEach {
            completedStampStackView.addArrangedSubview($0)
        }
    }
    
    
    private func setupDurationViews() {
        [durationCountLeadingLabel, durationCountTrailingLabel].forEach {
            durationCountView.addSubview($0)
        }
        
        durationCountLeadingLabel.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }
        
        durationCountTrailingLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6)
            $0.leading.equalTo(durationCountLeadingLabel.snp.trailing).offset(2)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(2)
        }
        
        [durationLabel, durationCountView].forEach {
            durationStackView.addArrangedSubview($0)
        }
    }
    
    
    private func setupAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDidTapMissionHeader))
        completedMissionHeaderView.addGestureRecognizer(tapGesture)
        completedMissionHeaderView.isUserInteractionEnabled = true
    }
    
    @objc private func handleDidTapMissionHeader() {
        delegate?.didTapMissionHeader()
    }
    
    func configure(completedMission: Int, completedStamp: Int, duration: String) {
        completedMissionCountLeadingLabel.text = "\(completedMission)"
        completedStampCountLeadingLabel.text = "\(completedStamp)"
        durationCountLeadingLabel.text = "\(duration)"
    }
}
