//
//  StampAllowCell.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/09/03.
//

import UIKit

import SnapKit

final class StampAllowCell: UICollectionViewListCell {
    static let reuseIdentifier = "StampAllowCell"
    
    private let wrapperView = UIView()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .body14Md
        label.textAlignment = .left
        label.text = "일이삼사오육칠팔구십일이삼사오육칠팔구십"
        label.textColor = .gray800
        return label
    }()
    
    private let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "nickname_check")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureLayout()
        deselectCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StampAllowCell {
    func selectCell() {
        wrapperView.layer.borderColor = UIColor.blue500.cgColor
        wrapperView.backgroundColor = .blue100
        titleLabel.textColor = .blue500
        checkImageView.alpha = 1
    }
    
    func deselectCell() {
        wrapperView.layer.borderColor = UIColor.gray300.cgColor
        wrapperView.backgroundColor = .white
        titleLabel.textColor = .gray800
        checkImageView.alpha = 0
    }
    
    private func configureView() {
        wrapperView.layer.cornerRadius = 8
        wrapperView.layer.borderColor = UIColor.gray300.cgColor
        wrapperView.layer.borderWidth = 1
    }
    
    private func configureLayout() {
        [titleLabel, checkImageView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [stackView].forEach {
            wrapperView.addSubview($0)
        }
        
        [wrapperView].forEach {
            contentView.addSubview($0)
        }
        
        checkImageView.snp.makeConstraints { make in
            make.width.height.equalTo(titleLabel.snp.height)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        wrapperView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(4)
        }
    }
}
