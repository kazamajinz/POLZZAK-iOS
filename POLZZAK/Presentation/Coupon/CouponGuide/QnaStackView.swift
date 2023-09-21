//
//  QnaStackView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/22.
//

import UIKit

class QnaStackView: UIStackView {
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.setStackView(axis: .horizontal, spacing: 8)
        return stackView
    }()
    
    private let checkImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .blue500
        imageView.image = .acceptButton?.withRenderingMode(.alwaysTemplate)
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .gray700, font: .subtitle16Bd)
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .gray600, font: .body14Md)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStack()
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupStack() {
        axis = .vertical
        spacing = 17
       }
    
    private func setupUI() {
        
        
        [checkImage, titleLabel].forEach {
            titleStackView.addArrangedSubview($0)
        }
        
        checkImage.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        [titleStackView, contentLabel].forEach {
            addArrangedSubview($0)
        }
    }
}
