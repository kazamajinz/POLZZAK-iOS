//
//  StampCell.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/22.
//

import UIKit

import SnapKit

class StampCell: UICollectionViewCell {
    static let reuseIdentifier = "StampCell"
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray400
        label.font = .pretendard(size: 24, family: .medium)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
    }
}

extension StampCell {
    private func configureView() {
        clipsToBounds = true
        contentView.backgroundColor = .gray200
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
