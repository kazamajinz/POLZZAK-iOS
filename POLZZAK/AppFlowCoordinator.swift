//
//  AppFlowCoordinator.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/11.
//

import UIKit

final class AppFlowCoordinator {
    
    func getRootView() -> TabBarController {
        //TODO: - 로그인 및 회원상태에 따라 분기처리할 예정
        if false == tempDummyData.isEmpty {
            let mainViewController = MainViewController(userInformations: tempDummyData)
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
            
            return tabBarController
        } else {
            return TabBarController()
        }
    }
}
