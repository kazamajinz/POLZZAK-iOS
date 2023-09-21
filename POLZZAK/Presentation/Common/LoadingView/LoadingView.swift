//
//  LoadingView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/15.
//

import UIKit

final class LoadingView: UIView {
    private let backgroundLayer = CAShapeLayer()
    private let rotatingLayer = CAShapeLayer()
    private var rotatingView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setLayers() {
        backgroundLayer.strokeColor = UIColor.blue200.cgColor
        backgroundLayer.lineWidth = 7
        backgroundLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(backgroundLayer)
        
        rotatingLayer.strokeColor = UIColor.blue500.cgColor
        rotatingLayer.lineWidth = 7
        rotatingLayer.fillColor = UIColor.clear.cgColor
        
        rotatingView = UIView(frame: bounds)
        rotatingView.layer.addSublayer(rotatingLayer)
        addSubview(rotatingView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setCenter()
        startRotating()
    }
    
    func setCenter() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = 34.83 / 2
        let startAngle: CGFloat = 0
        let endAngle: CGFloat = 2 * .pi

        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        backgroundLayer.path = path.cgPath
        backgroundLayer.lineCap = .round
        
        let rotatingPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: .pi / 2, clockwise: true)
        rotatingLayer.path = rotatingPath.cgPath
        rotatingLayer.lineCap = .round
        
        rotatingView.frame = bounds
    }
    
    func startRotating() {
        if rotatingView.layer.animation(forKey: "rotationAnimation") == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.byValue = Float.pi * 2
            rotationAnimation.duration = 1
            rotationAnimation.repeatCount = .infinity
            rotatingView.layer.add(rotationAnimation, forKey: "rotationAnimation")
        }
    }
    
    func stopRotating() {
        rotatingView.layer.removeAnimation(forKey: "rotationAnimation")
    }
}
