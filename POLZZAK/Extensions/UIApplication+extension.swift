//
//  UIApplication+extension.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/23.
//

import UIKit

extension UIApplication {
    static var keyWindow: UIWindow? {
        return UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
    
    static var width: CGFloat {
        return UIApplication
            .keyWindow?
            .screen
            .bounds
            .width ?? 0
    }
    
    static func getTopViewController(base: UIViewController? = UIApplication.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
