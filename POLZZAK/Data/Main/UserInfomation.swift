//
//  UserInfomation.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/05/18.
//

import Foundation

struct StampBoardSummary: Decodable {
    let stampBoardId: Int
    let name: String
    let currentStampCount: Int
    let goalStampCount: Int
    let reward: String
    let missionCompleteCount: Int
    let isRewarded: Bool
}

struct UserInformation: Decodable {
    let familyMember: FamilyMember
    let stampBoardSummaries: [StampBoardSummary]

    var unRewardedStampBoards: [StampBoardSummary] {
        return stampBoardSummaries.filter { false == $0.isRewarded }
    }
    
    var rewardedStampBoards: [StampBoardSummary] {
        return stampBoardSummaries.filter { true == $0.isRewarded }
    }
}
