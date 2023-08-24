//
//  AppFlowCoordinator.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/11.
//

import UIKit

final class AppFlowController {
    static let shared = AppFlowController()
    
    private var window: UIWindow?
    private var rootViewController: UIViewController? {
        didSet {
            animateChangingRootViewController(rootViewController)
        }
    }
    
    private init() {}
    
    func show(in window: UIWindow) {
        self.window = window
        window.makeKeyAndVisible()
        showHome()
    }
    
    func showHome() {
        rootViewController = getHomeViewController()
    }
    
    private func animateChangingRootViewController(_ rootViewController: UIViewController?) {
        guard let window else { return }
        UIView.transition(with: window, duration: 0.1, options: .transitionCrossDissolve, animations: {
            window.rootViewController = rootViewController
        })
    }
    
    private func getHomeViewController() -> TabBarController {
        //TODO: - 로그인 및 회원상태에 따라 분기처리할 예정
        let mainViewController = MainViewController(userInformations: tempDummyData)
        mainViewController.tabBarItem = UITabBarItem(title: "메인", image: .mainTabBarIcon, tag: 0)
        let mainNavigationController = UINavigationController(rootViewController: mainViewController)
        mainNavigationController.setNavigationBarStyle()
        
        let couponListViewController = CouponListViewController()
        couponListViewController.tabBarItem = UITabBarItem(title: "쿠폰", image: .couponTabBarIcon, tag: 1)
        let couponNavigationController = UINavigationController(rootViewController: couponListViewController)
        couponNavigationController.setNavigationBarStyle()
        
        let notificationViewController = NotificationViewController()
        notificationViewController.tabBarItem = UITabBarItem(title: "알림", image: .notificationTabBarIcon, tag: 2)
        let notificationNavigationController = UINavigationController(rootViewController: notificationViewController)
        notificationNavigationController.setNavigationBarStyle()
        
        let myPageViewController = UIViewController()
        myPageViewController.tabBarItem = UITabBarItem(title: "마이페이지", image: .myPageTabBarIcon, tag: 3)
        let myPageNavigationController = UINavigationController(rootViewController: myPageViewController)
        myPageNavigationController.setNavigationBarStyle()
        
        let tabBarController = TabBarController()
        tabBarController.viewControllers = [
            mainNavigationController,
            couponNavigationController,
            notificationNavigationController,
            myPageNavigationController
        ]
        
        tabBarController.modalPresentationStyle = .fullScreen
        
        return tabBarController
    }
    
}
