//
//  MissionHeaderView.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/12.
//

import UIKit

import SnapKit

class MissionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "MissionHeaderView"
    
    private let contentView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "미션 목록"
        label.font = .subtitle3
        label.textColor = .gray800
        return label
    }()
    
    private let moreButton = MoreButton(title: "더보기")
    
    private var titleLabelLeadingConstraint: Constraint?
    private var moreButtonTrailingConstraint: Constraint?
    
    var actionWhenUserTapMoreButton: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureMoreButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MissionHeaderView {    
    private func configureLayout() {
        addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(moreButton)
        
        moreButton.setContentCompressionResistancePriority(.init(1001), for: .horizontal)
        
        contentView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
            make.horizontalEdges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            self.titleLabelLeadingConstraint = make.leading.equalToSuperview().constraint
            make.trailing.lessThanOrEqualTo(moreButton.snp.leading).offset(-10)
        }
        
        moreButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            self.moreButtonTrailingConstraint = make.trailing.equalToSuperview().constraint
        }
    }
    
    private func configureMoreButton() {
        moreButton.addAction(
            UIAction(handler: { [weak self] _ in
                self?.moreButton.isSelected.toggle()
                self?.actionWhenUserTapMoreButton?()
            }),
            for: .touchUpInside
        )
    }
    
    func updateHorizontalInset(inset: CGFloat) {
        titleLabelLeadingConstraint?.update(inset: inset)
        moreButtonTrailingConstraint?.update(inset: inset)
    }
    
    func setMoreButtonHidden(isHidden: Bool) {
        moreButton.isHidden = isHidden
    }
}
