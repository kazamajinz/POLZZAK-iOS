//
//  StampBoardDetail.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/09/15.
//

import Foundation

struct StampBoardDetail {
    let stampBoardId: Int
    let name: String
    let status: DetailBoardState
    let kid: ChildInfo
    let currentStampCount, goalStampCount: Int
    let reward: String
    let missions: [Mission]
    let stamps: [StampInfo]?
    let missionRequestList: [MissionRequest]?
    let completedDate, rewardDate: Date?
    let createdDate: Date
}

struct ChildInfo {
    let id: Int
    let nickname: String
    let profileUrl: String
}

struct Mission: MissionListViewable {
    let id: Int
    let content: String
    
    var missionTitle: String {
        return content
    }
}

struct StampInfo {
    let id: String
    let stampDesignId: Int
    let missionContent: String
    let createdDate: Date
}

struct MissionRequest {
    let id: Int
    let missionId: Int
    let missionContent: String
    let createdDate: Date
}

// MARK: - StampBoardDetail Extension

extension StampBoardDetail {
    var dayPassed: Int {
        let c = Calendar.current
        let createdDay = c.component(.day, from: createdDate)
        let currentDay = c.component(.day, from: Date())
        return currentDay - createdDay
    }
}
