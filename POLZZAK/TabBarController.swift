//
//  TabBarController.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/05/15.
//

import UIKit

final class TabBarController: UITabBarController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setTabBarAtrribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setTabBarAtrribute() {
        let selectedColor: UIColor = .blue400
        let unselectedColor: UIColor = .gray200
        let selectedTextColor: UIColor = .gray500
        let unselectedTextColor: UIColor = .gray300
        
        let appearance = UITabBarAppearance()
        appearance.stackedLayoutAppearance.normal.iconColor = unselectedColor
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: unselectedTextColor]
        appearance.stackedLayoutAppearance.selected.iconColor = selectedColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: selectedTextColor]
        tabBar.standardAppearance = appearance
    }
}
