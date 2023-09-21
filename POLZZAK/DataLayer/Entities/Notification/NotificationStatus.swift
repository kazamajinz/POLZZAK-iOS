//
//  NotificationStatus.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/13.
//

import Foundation

enum NotificationStatus: String, CaseIterable {
    case read = "READ"
    case unread = "UNREAD"
    case requestLink = "REQUEST_FAMILY"
    case requestAccept = "REQUEST_FAMILY_ACCEPT"
    case requestReject = "REQUEST_FAMILY_REJECT"
}
