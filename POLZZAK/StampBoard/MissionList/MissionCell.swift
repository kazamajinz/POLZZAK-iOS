//
//  MissionCell.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/14.
//

import UIKit

import SnapKit

class MissionCell: UICollectionViewListCell {
    static let reuseIdentifier = "MissionCell"
    
    private let wrapperView = UIView()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .body3
        label.textAlignment = .left
        label.text = "미션 제목이 들어가는 자리입니다."
        return label
    }()
    
    private var titleLabelHorizontalEdgesConstraint: Constraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MissionCell {
    private func configureLayout() {
        contentView.addSubview(wrapperView)
        wrapperView.addSubview(titleLabel)
        
        wrapperView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
            make.horizontalEdges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            self.titleLabelHorizontalEdgesConstraint = make.horizontalEdges.equalToSuperview().constraint
        }
    }
    
    func updateHorizontalInset(inset: CGFloat) {
        titleLabelHorizontalEdgesConstraint?.update(inset: inset)
    }
}
