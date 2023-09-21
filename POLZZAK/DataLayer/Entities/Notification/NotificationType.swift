//
//  NotificationType.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/07/12.
//

import UIKit

enum NotificationType: String, CaseIterable {
    case requestLink = "FAMILY_REQUEST"
    case completedLink = "FAMILY_REQUEST_COMPLETE"
    case levelUp = "LEVEL_UP"
    case levelDown = "LEVEL_DOWN"
    case requestStamp = "STAMP_REQUEST"
    case requestReward = "REWARD_REQUEST"
    case completedStampBoard = "STAMP_BOARD_COMPLETE"
    case receivedReward = "REWARDED"
    case oneDayLeftReward = "REWARD_REQUEST_AGAIN"
    case brokenReward = "REWARD_FAIL"
    case createStampBoard = "CREATED_STAMP_BOARD"
    case receivedCoupon = "ISSUED_COUPON"
    case requestCompleteTap = "REWARDED_REQUEST"
    
    var isButtonHidden: Bool {
        switch self {
        case .requestLink:
            return false
        default:
            return true
        }
    }
    
    var isSenderHidden: Bool {
        switch self {
        case .levelUp, .levelDown, .requestCompleteTap:
            return true
        default:
            return false
        }
    }
}
