//
//  UIApplication+width.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/23.
//

import UIKit

extension UIApplication {
    var width: CGFloat? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.screen.bounds.width
    }
}
