//
//  UIViewController+extension.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/05/18.
//

import UIKit

extension UIViewController {
    func topViewController(controller: UIViewController? = UIApplication.shared.connectedScenes
        .filter { $0.activationState == .foregroundActive }
        .map { $0 as? UIWindowScene }
        .compactMap { $0 }
        .first?.windows
        .filter { $0.isKeyWindow }.first?.rootViewController) -> UIViewController? {
            if let navigationController = controller as? UINavigationController {
                return topViewController(controller: navigationController.topViewController)
            }
            if let tabController = controller as? UITabBarController {
                if let selected = tabController.selectedViewController {
                    return topViewController(controller: selected)
                }
            }
            if let presented = controller?.presentedViewController {
                return topViewController(controller: presented)
            }
            return controller
        }
}
