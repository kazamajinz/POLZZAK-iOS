//
//  DetailBoardNameView.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/25.
//

import UIKit

import SnapKit

final class DetailBoardNameView: UIView {
    private let contentView = UIView()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .title1
        label.textAlignment = .left
        return label
    }()
    
    private let dayLabel: UILabel = {
        let label = LabelWithPadding(padding: .init(top: 4, left: 8, bottom: 4, right: 8))
        label.font = .subtitle3
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .blue500
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        return label
    }()
    
    private let horizontalInset: CGFloat
    
    init(frame: CGRect = .zero, horizontalInset: CGFloat = 0) {
        self.horizontalInset = horizontalInset
        super.init(frame: frame)
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailBoardNameView {
    func setNameTitle(name: String) {
        nameLabel.text = name
    }
    
    func setDayTitle(state: DetailBoardState, dayPassed: Int) {
        switch state {
        case .progress, .completed, .issuedCoupon:
            dayLabel.text = "D+\(dayPassed)"
        case .rewarded:
            dayLabel.text = "\(dayPassed)일 걸렸어요!"
        }
    }
    
    private func configureView() {
        backgroundColor = .clear
        nameLabel.text = "도장판 이름"
        dayLabel.text = "D+9"
    }
    
    private func configureLayout() {
        addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(horizontalInset)
            make.verticalEdges.equalToSuperview().inset(20)
        }
        
        [nameLabel, dayLabel].forEach {
            contentView.addSubview($0)
        }
        
        dayLabel.setContentCompressionResistancePriority(.init(751), for: .horizontal)
        dayLabel.setContentHuggingPriority(.init(251), for: .horizontal)
        
        nameLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalTo(dayLabel.snp.leading).offset(-10)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
        }
    }
}
