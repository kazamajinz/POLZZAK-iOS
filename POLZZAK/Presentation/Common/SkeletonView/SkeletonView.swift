//
//  SkeletonView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/16.
//

import UIKit

//TODO: - 라이브러리 제거 후 네이밍 변경
class SkeletonView: UIView {
    private var didStartShimmering = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray200
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startShimmering() {
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.fromValue = UIColor.gray200.cgColor
        animation.toValue = UIColor.gray300.cgColor
        animation.duration = 1.0
        animation.autoreverses = true
        animation.repeatCount = .infinity
        
        self.layer.add(animation, forKey: "backgroundColorShimmering")
    }
    
    func stopShimmering() {
        self.layer.removeAnimation(forKey: "backgroundColorShimmering")
    }

}
