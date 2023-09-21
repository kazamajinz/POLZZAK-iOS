//
//  NotificationLink.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/14.
//

import Foundation

enum NotificationLink: Equatable {
    case home
    case myPage
    case stampBoard(stampBoardID: Int)
    case coupon(couponID: Int)
}
