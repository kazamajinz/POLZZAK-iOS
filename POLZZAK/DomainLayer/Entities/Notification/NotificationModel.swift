//
//  Notification.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/07/12.
//

import Foundation

struct NotificationResponse {
    let startID: Int
    let notificationList: [Notification]?
}

struct Notification {
    let id: Int
    let type: NotificationType?
    let status: NotificationStatus?
    let title: String
    let message: String
    let sender: Sender?
    let link: NotificationLink?
    let requestFamilyID: Int?
    let createdDate: String
}
