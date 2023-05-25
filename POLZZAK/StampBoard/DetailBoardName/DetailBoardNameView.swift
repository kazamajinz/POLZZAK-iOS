//
//  DetailBoardNameView.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/25.
//

import UIKit

import SnapKit

enum StampBoardState {
    case inProgress(dayRemained: Int)
    case completed(dayTaken: Int)
}

class DetailBoardNameView: UIView {
    private let nameLabel: UILabel = {
        let label = UILabel()
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
    
    func setDayTitle(state: StampBoardState) {
        switch state {
        case .inProgress(let dayRemained):
            nameLabel.text = "D+\(dayRemained)"
        case .completed(let dayTaken):
            dayLabel.text = "\(dayTaken)일 걸렸어요!"
        }
    }
    
    private func configureView() {
        backgroundColor = .clear
        nameLabel.text = "도장판 이름"
        dayLabel.text = "D+9"
    }
    
    private func configureLayout() {
        addSubview(nameLabel)
        addSubview(dayLabel)
        
        nameLabel.setContentCompressionResistancePriority(.init(1001), for: .horizontal)
        
        self.snp.makeConstraints { make in
            make.height.equalTo(55)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview().inset(horizontalInset)
            make.trailing.lessThanOrEqualTo(dayLabel.snp.leading).offset(-10)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.height.lessThanOrEqualToSuperview()
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(horizontalInset)
        }
    }
}
