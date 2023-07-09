//
//  EmptyView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/16.
//

import UIKit
import SnapKit

final class EmptyView: UIView {
    private var topConstraint: Constraint?
    var topSpacing: CGFloat = 128 {
        didSet {
            topConstraint?.update(offset: topSpacing)
        }
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .white
        
        [imageView, label].forEach {
            addSubview($0)
        }
        
        imageView.snp.makeConstraints {
            topConstraint = $0.top.equalToSuperview().offset(topSpacing).constraint
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(100)
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
    }
    
    func hideBackgroundView() {
        isHidden = true
    }
    
    func showBackgroundView() {
        isHidden = false
    }
}
