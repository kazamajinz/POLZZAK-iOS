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
    
    let imageView: UIImageView = {
        let imageView = UIImageView(frame: .init(x: 0, y: 0, width: 26, height: 26))
        imageView.layer.cornerRadius = 13
        imageView.backgroundColor = .blue200.withAlphaComponent(0.5)
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .body3
        label.textAlignment = .left
        label.text = "미션 제목이 들어가는 자리입니다."
        return label
    }()
    
    private var imageViewLeadingConstraint: Constraint?
    private var titleLabelTrailingConstraint: Constraint?
    
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
        wrapperView.addSubview(imageView)
        wrapperView.addSubview(titleLabel)
        
        wrapperView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
            make.horizontalEdges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            self.imageViewLeadingConstraint = make.leading.equalToSuperview().constraint
            make.top.lessThanOrEqualToSuperview()
            make.bottom.greaterThanOrEqualToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(26)
            make.width.equalTo(imageView.snp.height)
            make.trailing.equalTo(titleLabel.snp.leading).offset(-12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            self.titleLabelTrailingConstraint = make.trailing.equalToSuperview().constraint
        }
    }
    
    func updateInset(inset: CGFloat) {
        imageViewLeadingConstraint?.update(inset: inset)
        titleLabelTrailingConstraint?.update(inset: inset)
    }
}
