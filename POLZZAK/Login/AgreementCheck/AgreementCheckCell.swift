//
//  AgreementCheckCell.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/07/21.
//

import UIKit

import SnapKit

class AgreementCheckCell: UITableViewCell {
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
        button.configuration = config
        button.configurationUpdateHandler = { button in
            switch button.state {
            case .selected:
                button.configuration?.image = UIImage(named: "agreement_check_circle_filled")?.withTintColor(.blue500)
            default:
                button.configuration?.image = UIImage(named: "agreement_check_circle_filled")?.withTintColor(.gray300)
            }
        }
        return button
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .body15Md
        return label
    }()
    
    private let rightArrow: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "chevron_right_small")?.withTintColor(.gray400), for: .normal)
        return button
    }()
    
    private var leadingConstraint: Constraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        contentView.addSubview(stackView)
        
        [checkButton, contentLabel, rightArrow].forEach {
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
        
        rightArrow.snp.makeConstraints { make in
            make.height.width.equalTo(24)
        }
        
        // TODO: 밑에 두개 설정 안하면 라벨 text 많아졌을때 어떻게 되는지 확인하고 필요없으면 삭제
        checkButton.setContentCompressionResistancePriority(.init(751), for: .horizontal)
        rightArrow.setContentCompressionResistancePriority(.init(751), for: .horizontal)
    }
    
    func updateLeadingInset(inset: CGFloat) {
        leadingConstraint?.update(inset: inset)
    }
    
    func setLabelStyle(font: UIFont, textColor: UIColor) {
        contentLabel.font = font
        contentLabel.textColor = textColor
    }
    
    func setLabelText(text: String?) {
        contentLabel.text = text
    }
}
