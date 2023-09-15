//
//  UIView+extension.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/05/20.
//

import UIKit

extension UIView {
    func addBorder(
        corners: CACornerMask = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner],
        cornerRadius: CGFloat = 0.0,
        borderWidth: CGFloat = 0.0,
        borderColor: UIColor = .clear,
        masksToBounds: Bool = true
    ) {
        self.layer.maskedCorners = corners
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.masksToBounds = masksToBounds
    }
    
    func addDashedBorder(borderColor: UIColor, spacing: NSNumber, cornerRadius: CGFloat) {
        let color = borderColor.cgColor
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [spacing, spacing]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: cornerRadius).cgPath
        
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.layer.addSublayer(shapeLayer)
    }
}
