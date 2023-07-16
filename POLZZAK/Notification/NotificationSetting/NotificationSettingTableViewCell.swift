//
//  NotificationSettingTableViewCell.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/07/15.
//

import UIKit
import SnapKit

final class NotificationSettingTableViewCell: UITableViewCell {
    static let reuseIdentifier = "NotificationSettingTableViewCell"
    var topConstraint: Constraint?
    
    private let headerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4
        stackView.axis = .vertical
        return stackView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.setLabel(text: "모든알림", textColor: .gray800, font: .subtitle3)
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.setLabel(textColor: .gray500, font: .caption2)
        return label
    }()
    
    let customSwitch: CustomSwitch = {
        let customSwitfch = CustomSwitch()
        return customSwitfch
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NotificationSettingTableViewCell {
    private func setUI() {
        contentView.backgroundColor = .gray100
        
        [titleLabel, customSwitch].forEach {
            headerView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        customSwitch.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.width.equalTo(45)
            $0.height.equalTo(24)
        }
        
        [headerView, detailLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [stackView].forEach {
            contentView.addSubview($0)
        }
        
        stackView.snp.makeConstraints {
            topConstraint = $0.top.equalTo(24).constraint
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
    
    func configure(titleText: String = "", detailText: String = "", isSwitchOn: Bool) {
        if titleText != "", detailText != "" {
            detailLabel.isHidden = false
            topConstraint?.update(offset: 32)
            titleLabel.setLabel(text: titleText, textColor: .gray800, font: .body8)
            detailLabel.setLabel(text: detailText, textColor: .gray500, font: .caption2)
        }
        customSwitch.isSwitchOn = isSwitchOn
    }
}
