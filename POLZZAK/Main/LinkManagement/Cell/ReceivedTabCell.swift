//
//  ReceivedTabCell.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/15.
//

import UIKit
import SnapKit

protocol ReceivedTabCellDelegate: AnyObject {
    func didTapAccept(on cell: ReceivedTabCell)
    func didTapReject(on cell: ReceivedTabCell)
}

final class ReceivedTabCell: UITableViewCell {
    static let reuseIdentifier = "ReceivedTabCell"
    weak var delegate: ReceivedTabCellDelegate?
    var family: FamilyMember?
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .defaultProfileCharacter
        imageView.contentMode = .scaleAspectFit
        imageView.setCustomView(cornerRadius: 16)
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .gray800, font: .body2)
        return label
    }()
    
    private let buttonView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let acceptButton: UIButton = {
        let button = UIButton()
        let labelStyle = LabelStyle(text: "수락", textColor: .white, font: .body2, backgroundColor: .blue500)
        let borderStyle = BorderStyle(cornerRadius: 6)
        button.setCustomButton(labelStyle: labelStyle, borderStyle: borderStyle)
        return button
    }()
    
    private let rejectButton: UIButton = {
        let button = UIButton()
        let labelStyle = LabelStyle(text: "거절", textColor: .white, font: .body2, backgroundColor: .error500)
        let borderStyle = BorderStyle(cornerRadius: 6)
        button.setCustomButton(labelStyle: labelStyle, borderStyle: borderStyle)
        return button
    }()
    
    private let stampRewardView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        acceptButton.addTarget(self, action: #selector(acceptButtonClicked), for: .touchUpInside)
        rejectButton.addTarget(self, action: #selector(rejectButtonClicked), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        setUI()
    }
    
    private func setUI() {
        selectionStyle = .none
        
        [profileImage, titleLabel, buttonView].forEach {
            addSubview($0)
        }
        
        [acceptButton, rejectButton].forEach {
            buttonView.addSubview($0)
        }
        
        profileImage.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(profileImage.snp.height)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(18)
            $0.leading.equalTo(profileImage.snp.trailing).offset(10)
        }
        
        buttonView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(14)
            $0.leading.equalTo(titleLabel.snp.trailing)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        acceptButton.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(57)
        }

        rejectButton.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.leading.equalTo(acceptButton.snp.trailing).offset(10)
            $0.width.equalTo(57)
        }
    }
    
    func configure(family: FamilyMember) {
        self.family = family
        profileImage.loadImage(from: family.profileURL)
        titleLabel.text = family.nickName
    }
    
    private func reset() {
        profileImage.image = .defaultProfileCharacter
    }
    
    @objc private func acceptButtonClicked() {
        delegate?.didTapAccept(on: self)
    }
    
    @objc private func rejectButtonClicked() {
        delegate?.didTapReject(on: self)
    }
}
