//
//  StampSelectionCell.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/09/05.
//

import UIKit

import SnapKit

final class StampSelectionCell: UICollectionViewCell {
    static let reuseIdentifier = "StampSelectionCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .gray200
        return imageView
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
        contentView.layer.cornerRadius = contentView.frame.height / 2
    }
    
    private func configureView() {
        contentView.backgroundColor = .gray200
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func configureLayout() {
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(image: UIImage?) {
        imageView.image = image
    }
    
    func emphasizeCell() {
        contentView.layer.borderColor = UIColor.blue500.cgColor
    }
    
    func unEmphasizeCell() {
        contentView.layer.borderColor = UIColor.clear.cgColor
    }
}
