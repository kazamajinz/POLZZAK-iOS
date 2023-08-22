//
//  CouponListEmptyView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/22.
//

import UIKit

class CouponListEmptyView: UIView {
    private let subView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.setStackView(axis: .vertical, spacing: 12)
        stackView.alignment = .center
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .couponEmptyCharacter
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .gray800, font: .body14Md, textAlignment: .center)
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        addSubview(subView)
        
        subView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        [imageView, placeHolderLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        subView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
