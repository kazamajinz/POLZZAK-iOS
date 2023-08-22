//
//  UIView+Capture.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/20.
//

import UIKit

extension UIView {
    func capture() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        self.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
