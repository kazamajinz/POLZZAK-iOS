//
//  EmptyView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/16.
//

import UIKit
import SnapKit

final class EmptyView: UIView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .sittingCharacter
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        return label
    }()
    
    init(frame: CGRect = .zero, style: TabStyle) {
        super.init(frame: frame)
        setUI(with: style)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI(with style: TabStyle) {
        label.setLabel(with: style.labelStyle)
        
        [imageView, label].forEach {
            addSubview($0)
        }
        
        imageView.snp.makeConstraints {
            //MARK: - topContraint가 0일 경우 가운데로 가도록.
            if style.topConstraint == 0 {
                $0.centerY.equalToSuperview()
            } else {
                $0.top.equalTo(style.topConstraint)
            }
            
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(100)
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setStyle(_ style: TabStyle) {
        label.setLabel(with: style.labelStyle)
    }
    
    func hideBackgroundView() {
        isHidden = true
    }
    
    func showBackgroundView() {
        isHidden = false
    }
}
