//
//  NotLinkCell.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/15.
//

import UIKit

final class NotLinkCell: UICollectionViewCell {
    static let reuseIdentifier = "NotLinkCell"
    
    private let subView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
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
        label.textColor = .gray800
        label.font = .body14Md
        label.textAlignment = .center
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
        contentView.addSubview(subView)
        contentView.addDashedBorder(borderColor: .gray300, spacing: 3, cornerRadius: 8)
        
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
    
    func configure(with text: String) {
        placeHolderLabel.text = text + "와 연동되면\n도장판을 만들 수 있어요!"
    }
}
