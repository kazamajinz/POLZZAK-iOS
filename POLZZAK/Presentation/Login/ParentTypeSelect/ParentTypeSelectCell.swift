//
//  ParentTypeSelectCell.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/02.
//

import UIKit

import SnapKit

final class ParentTypeSelectCell: UICollectionViewCell {
    static let reuseIdentifier = "ParentTypeSelectCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .subtitle16Md
        label.textColor = .gray300
        label.text = "선택해 주세요"
        label.backgroundColor = .clear
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.white.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 5
    }
    
    private func configureLayout() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    func emphasizeCell() {
        contentView.backgroundColor = .blue100
        titleLabel.textColor = .blue600
        contentView.layer.borderColor = UIColor.blue500.cgColor
    }
    
    func unEmphasizeCell() {
        contentView.backgroundColor = .white
        titleLabel.textColor = .gray300
        contentView.layer.borderColor = UIColor.white.cgColor
    }
}
