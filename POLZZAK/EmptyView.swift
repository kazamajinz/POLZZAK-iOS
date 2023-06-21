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
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    init(frame: CGRect = .zero, style: EmptyStyleProtocol) {
        super.init(frame: frame)
        setUI(style: style)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI(style: EmptyStyleProtocol) {
        label.setLabel(style: style.labelStyle)
        imageView.image = style.emptyImage
        
        backgroundColor = .white
        
        [imageView, label].forEach {
            addSubview($0)
        }
        
        imageView.snp.makeConstraints {
            //MARK: - topContraint가 0일 경우 가운데로 가도록.
            if style.topConstraint == 0 {
                $0.centerY.equalToSuperview()
            } else {
                self.topConstraint = $0.top.equalToSuperview().constraint
            }
            
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(100)
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        updateUI(offset: style.topConstraint)
    }
    
    func setStyle(_ style: EmptyStyleProtocol) {
        label.setLabel(style: style.labelStyle)
        imageView.image = style.emptyImage
        updateUI(offset: style.topConstraint)
        self.layoutIfNeeded()
    }
    
    func updateUI(offset: CGFloat) {
        topConstraint?.update(offset: offset)
    }
    
    func hideBackgroundView() {
        isHidden = true
    }
    
    func showBackgroundView() {
        isHidden = false
    }
}
