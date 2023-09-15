//
//  StampSizeSelectionCell.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/09/16.
//

import UIKit

import SnapKit

class StampSizeSelectionCell: UICollectionViewCell {
    static let reuseIdentifier = "StampSizeSelectionCell"
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray400
        label.font = .subtitle16Sbd
        label.textAlignment = .center
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
}

extension StampSizeSelectionCell {
    private func configureView() {
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.layer.borderColor = UIColor.gray300.cgColor
        contentView.layer.borderWidth = 1
    }
    
    private func configureLayout() {
        contentView.addSubview(numberLabel)
        
        numberLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setNumber(number: Int) {
        numberLabel.text = "\(number)"
    }
}
