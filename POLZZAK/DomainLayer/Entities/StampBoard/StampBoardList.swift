//
//  StampBoardList.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/30.
//

import Foundation

struct StampBoardList {
    let family: FamilyMember
    let stampBoardSummaries: [StampBoardSummary]
}

struct StampBoardSummary {
    let stampBoardId: Int
    let name: String
    let currentStampCount: Int
    let goalStampCount: Int
    let reward: String
    let missionRequestCount: Int
    let status: StampBoardStatus?
}

enum StampBoardStatus: String {
    case progress = "PROGRESS"
    case completed = "COMPLETED"
    case issuedCoupon = "ISSUED_COUPON"
    case rewarded = "REWARDED"
}
