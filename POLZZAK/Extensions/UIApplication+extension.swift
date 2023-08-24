//
//  UIApplication+extension.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/23.
//

import UIKit

extension UIApplication {
    var keyWindow: UIWindow? {
        return UIApplication
            .shared
            .connectedScenes
        //TODO: - 수정필요
//            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
    
    var width: CGFloat {
        return UIApplication
            .shared
            .keyWindow?
            .screen
            .bounds
            .width ?? 0
    }
    
    var height: CGFloat {
        return UIApplication
            .shared
            .keyWindow?
            .screen
            .bounds
            .height ?? 0
    }
    
    var statusBarHeight: CGFloat {
        return UIApplication
            .shared
            .keyWindow?
            .windowScene?
            .statusBarManager?
            .statusBarFrame
            .height ?? 0
    }
    
    private var keyWindowRootVC: UIViewController? {
        if Thread.isMainThread {
            return UIApplication
                .shared
                .keyWindow?
                .rootViewController
        } else {
            return DispatchQueue.main.sync {
                UIApplication
                    .shared
                    .keyWindow?
                    .rootViewController
            }
        }
    }
    
    static func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindowRootVC) -> UIViewController? {
        if let nav = base as? UINavigationController, let visible = nav.visibleViewController {
            return getTopViewController(base: visible)
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
