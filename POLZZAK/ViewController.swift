//
//  ViewController.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/11.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        start(UserInformation: tempDummyData)
    }
    
}

extension ViewController {
    private func start(UserInformation: [UserInformation]) {
        let mainViewController = MainViewController(userInformations: UserInformation)
        mainViewController.tabBarItem = UITabBarItem(title: "메인", image: .mainTabBarIcon, tag: 0)
        let mainNavigationController = UINavigationController(rootViewController: mainViewController)
        
        let couponViewController = UIViewController()
        couponViewController.tabBarItem = UITabBarItem(title: "쿠폰", image: .couponTabBarIcon, tag: 1)
        let couponNavigationController = UINavigationController(rootViewController: couponViewController)
        
        let notificationViewController = UIViewController()
        notificationViewController.tabBarItem = UITabBarItem(title: "알림", image: .notificationTabBarIcon, tag: 2)
        let notificationNavigationController = UINavigationController(rootViewController: notificationViewController)
        
        let myPageViewController = UIViewController()
        myPageViewController.tabBarItem = UITabBarItem(title: "마이페이지", image: .myPageTabBarIcon, tag: 3)
        let myPageNavigationController = UINavigationController(rootViewController: myPageViewController)
        
        let tabBarController = TabBarController()
        tabBarController.viewControllers = [
            mainNavigationController,
            couponNavigationController,
            notificationNavigationController,
            myPageNavigationController
        ]
        
        tabBarController.modalPresentationStyle = .fullScreen
        self.present(tabBarController, animated: false, completion: nil)
    }
}
