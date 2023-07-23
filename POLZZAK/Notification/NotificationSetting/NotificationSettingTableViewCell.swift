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
        label.setLabel(textColor: .gray800, font: .body8)
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .gray500, font: .caption2)
        return label
    }()
    
    let customSwitch: UISwitch = {
        let customSwitfch = UISwitch()
        customSwitfch.onTintColor = .blue500
        return customSwitfch
    }()
    
    let bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        return view
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
            $0.top.leading.bottom.equalToSuperview()
            $0.height.equalTo(customSwitch.snp.height)
        }
        
        customSwitch.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.leading.equalTo(titleLabel.snp.trailing)
        }
        
        [headerView, detailLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [stackView, bottomLine].forEach {
            contentView.addSubview($0)
        }
        
        stackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        bottomLine.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
    }
    
    func configure(titleText: String = "", detailText: String = "", isSwitchOn: Bool) {
        titleLabel.text = titleText
        detailLabel.text = detailText
        customSwitch.isOn = isSwitchOn
    }
    
    func hideBottomLine() {
        bottomLine.backgroundColor = .gray100
    }
}
