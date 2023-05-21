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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "미션 목록"
        label.font = .subtitle3
        label.textColor = .gray800
        return label
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        var titleContainer = AttributeContainer()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 10)
        titleContainer.font = .body4
        titleContainer.foregroundColor = .gray500
        config.attributedTitle = AttributedString("더보기", attributes: titleContainer)
        config.preferredSymbolConfigurationForImage = imageConfig
        config.imagePlacement = .trailing
        config.imagePadding = 6
        config.background.cornerRadius = 0
        config.background.backgroundColor = .white
        config.cornerStyle = .fixed
        button.configuration = config
        button.configurationUpdateHandler = { button in
            switch button.state {
            case .selected:
                button.configuration?.image = UIImage(systemName: "chevron.up")?.withTintColor(.gray500, renderingMode: .alwaysOriginal)
            default:
                button.configuration?.image = UIImage(systemName: "chevron.down")?.withTintColor(.gray500, renderingMode: .alwaysOriginal)
            }
        }
        return button
    }()
    
    private var titleLabelLeadingConstraint: Constraint?
    private var moreButtonTrailingConstraint: Constraint?
    
    var userTapMoreButton: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MissionHeaderView {
    private func configure() {
        configureView()
        configureLayout()
        configureMoreButton()
    }
    
    private func configureView() {
        addSubview(titleLabel)
        addSubview(moreButton)
    }
    
    private func configureLayout() {
        moreButton.setContentCompressionResistancePriority(.init(1001), for: .horizontal)
        
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
                self?.userTapMoreButton?()
            }),
            for: .touchUpInside
        )
    }
    
    func updateInset(inset: CGFloat) {
        titleLabelLeadingConstraint?.update(inset: inset)
        moreButtonTrailingConstraint?.update(inset: inset)
    }
}
