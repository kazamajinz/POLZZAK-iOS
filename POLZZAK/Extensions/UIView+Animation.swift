//
//  UIView+Animation.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/13.
//

import UIKit

extension UIView {
    func animateFrameChange(to newFrame: CGRect, duration: TimeInterval = 0.25) {
        UIView.animate(withDuration: duration) {
            self.frame = newFrame
        }
    }
}
