//
//  LinkListTabCell.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/14.
//

import UIKit
import SnapKit

protocol LinkListTabCellDelegate: AnyObject {
    func didTapClose(on cell: LinkListTabCell)
}

final class LinkListTabCell: UITableViewCell {
    static let reuseIdentifier = "LinkListCell"
    weak var delegate: LinkListTabCellDelegate?
    var family: FamilyMember?
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .defaultProfileCharacter
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .gray800, font: .body2)
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.closeButton, for: .normal)
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
        
        closeButton.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)
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
        
        [profileImage, titleLabel, closeButton].forEach {
            addSubview($0)
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
        
        closeButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.equalTo(titleLabel.snp.trailing)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(closeButton.snp.height)
        }
        
        profileImage.setCustomView(cornerRadius: profileImage.bounds.width / 2)
    }
    
    func configure(with family: FamilyMember) {
        self.family = family
        profileImage.loadImage(from: family.profileURL)
        titleLabel.text = family.nickName
    }
    
    private func reset() {
        profileImage.image = .defaultProfileCharacter
    }
    
    @objc func closeButtonClicked() {
        delegate?.didTapClose(on: self)
    }
}
