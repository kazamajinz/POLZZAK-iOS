//
//  UIViewController+UINavigation.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/17.
//

import UIKit

extension UIViewController {
    func setNavigationBarStyle(backgroundColor: UIColor = .white) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = backgroundColor
        appearance.shadowColor = nil
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}
