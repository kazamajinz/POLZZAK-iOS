//
//  StampGraphView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/05/20.
//

import UIKit

class StampGraphView: UIView {
    var blueShapeLayer: CAShapeLayer?
    
    var tempColor: CGColor = UIColor.clear.cgColor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: rect.width/2, y: rect.height/2),
                    radius: rect.width/2,
                    startAngle: CGFloat(130).degreesToRadians,
                    endAngle: CGFloat(50).degreesToRadians,
                    clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.blue100.cgColor
        shapeLayer.lineWidth = 18
        shapeLayer.lineCap = .round
        
        layer.addSublayer(shapeLayer)
    }
    
    func reset() {
        blueShapeLayer?.removeAllAnimations()
        blueShapeLayer?.removeFromSuperlayer()
        blueShapeLayer = nil
    }
    
    func startAnimation(withValue value: CGFloat) {
        let endAngle: CGFloat = 130 + 280 * value
        
        let bluePath = UIBezierPath()
        bluePath.addArc(withCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2),
                        radius: bounds.width / 2,
                        startAngle: CGFloat(130).degreesToRadians,
                        endAngle: endAngle.degreesToRadians,
                        clockwise: true)
        
        blueShapeLayer = CAShapeLayer()
        blueShapeLayer?.path = bluePath.cgPath
        blueShapeLayer?.fillColor = UIColor.clear.cgColor
        blueShapeLayer?.strokeColor = UIColor.blue400.cgColor
        blueShapeLayer?.lineWidth = 18
        blueShapeLayer?.lineCap = .round
        layer.addSublayer(blueShapeLayer ?? CAShapeLayer())
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        blueShapeLayer?.add(animation, forKey: "animateStrokeEnd")
    }
}

extension CGFloat {
    var degreesToRadians: CGFloat { return self * .pi / 180 }
}
