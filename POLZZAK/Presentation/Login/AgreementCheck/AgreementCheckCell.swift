//
//  AgreementCheckCell.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/07/21.
//

import UIKit

import SnapKit

final class AgreementCheckCell: UITableViewCell {
    static let reuseIdentifier = "AgreementCheckCell"
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private let checkButton: UIButton = {
        let button = UIButton(type: .custom)
        var config = UIButton.Configuration.plain()
        config.baseBackgroundColor = .clear
        button.configuration = config
        button.configurationUpdateHandler = { button in
            let image = UIImage(named: "agreement_check_circle_filled")
            button.isHighlighted = false
            switch button.state {
            case .selected:
                button.configuration?.image = image
                button.configuration?.baseForegroundColor = .blue500
            default:
                button.configuration?.image = image
                button.configuration?.baseForegroundColor = .gray300
            }
        }
        button.isSelected = false
        return button
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .body15Md
        return label
    }()
    
    private let rightArrowButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "chevron_right_small")
        button.setImage(image, for: .normal)
        button.setImage(image, for: .highlighted)
        button.imageView?.tintColor = .gray400
        return button
    }()
    
    var agreeAction: (() -> ())?
    var rightArrowAction: (() -> ())?
    
    private var leadingConstraint: Constraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        configureLayout()
        configureAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        backgroundColor = .gray100
    }
    
    private func configureLayout() {
        contentView.addSubview(stackView)
        
        [checkButton, contentLabel, rightArrowButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.snp.makeConstraints { make in
            leadingConstraint = make.leading.equalToSuperview().inset(16).constraint
            make.trailing.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview().inset(10)
        }
        
        checkButton.snp.makeConstraints { make in
            make.height.width.equalTo(24)
        }
        
        rightArrowButton.snp.makeConstraints { make in
            make.height.width.equalTo(24)
        }
        
        // TODO: 밑에 두개 설정 안하면 라벨 text 많아졌을때 어떻게 되는지 확인하고 필요없으면 삭제
        checkButton.setContentCompressionResistancePriority(.init(751), for: .horizontal)
        rightArrowButton.setContentCompressionResistancePriority(.init(751), for: .horizontal)
    }
    
    private func configureAction() {
        checkButton.addAction(.init(handler: { [weak self] _ in
            self?.userTapToAgree()
        }), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userTapToAgree))
        contentLabel.addGestureRecognizer(tapGesture)
        contentLabel.isUserInteractionEnabled = true
        
        rightArrowButton.addAction(.init(handler: { [weak self] _ in
            self?.rightArrowAction?()
        }), for: .touchUpInside)
    }
    
    @objc
    private func userTapToAgree() {
        agreeAction?()
    }
    
    func configure(data: AgreementTerm) {
        contentLabel.text = data.title
        contentLabel.font = data.font
        contentLabel.textColor = data.isAccepted ? data.selectedTextColor : data.normalTextColor
        checkButton.isSelected = data.isAccepted
        contentView.backgroundColor = data.backgroundColor
        rightArrowButton.isHidden = data.contentsURL == nil
        
        switch data.type {
        case .main:
            leadingConstraint?.update(inset: 16)
        case .sub:
            leadingConstraint?.update(inset: 24)
        }
    }
}
