//
//  ViewController.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/11.
//

import UIKit

class ViewController: UIViewController {

    let dummyUserInformations = (1...5).map { i -> UserInformation in
        UserInformation(
            partner: Partner(
                memberId: i,
                nickname: "해린맘\(i+14)",
                memberType: .kid,
                profileUrl: "http://polzzak.s3.ap-northeast-2.amazonaws.com/profile/81e05244-a040-436d-9608-319861ea2e51.png",
                kid: true
            ),
            stampBoardSummaries: (1...5).map { j -> StampBoardSummary in
                StampBoardSummary(
                    stampBoardId: j+7,
                    name: "테스트 도장판 \(j*11+22)",
                    currentStampCount: (0...30).randomElement() ?? 0,
                    goalStampCount: 30,
                    reward: "칭찬 \(j)",
                    missionCompleteCount: (0...30).randomElement() ?? 0,
                    isRewarded: false
                )
            }
        )
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        start(UserInformation: dummyUserInformations)
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
