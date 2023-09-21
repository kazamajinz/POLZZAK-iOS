//
//  TabBarController.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/05/15.
//

import UIKit
import UserNotifications

final class TabBarController: UITabBarController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setTabBarAtrribute()
        
        //TODO: - 최초화면에 옮길예정, 로그인화면으로 예상됨.
        checkNotificationAuthorizationStatus()
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
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        tabBar.standardAppearance = appearance
    }
    
    //TODO: - 최초화면에 옮길예정, 로그인화면으로 예상됨.
    func checkNotificationAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestNotificationAuthorization()
            case .authorized, .provisional:
#if DEBUG
                print("Notification authorization already granted")
#endif
            case .denied:
#if DEBUG
                print("Notification authorization denied earlier by user")
#endif
            case .ephemeral:
#if DEBUG
                print("The app is authorized to post noninterruptive user notifications")
#endif
            @unknown default:
#if DEBUG
                print("Unknown notification authorization status")
#endif
            }
        }
    }
    
    //TODO: - 최초화면에 옮길예정, 로그인화면으로 예상됨.
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification authorization granted")
            } else {
                print("Notification authorization denied")
            }
        }
    }
}
