//
//  StampBoardDetailDTO.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/09/14.
//

import Foundation

// MARK: - StampBoardDetailDTO

struct StampBoardDetailDTO: Decodable {
    let stampBoardId: Int
    let name, status: String
    let kid: ChildInfoDTO
    let currentStampCount, goalStampCount: Int
    let reward: String
    let missions: [MissionDTO]
    let stamps: [StampInfoDTO]?
    let missionRequestList: [MissionRequestDTO]?
    let completedDate, rewardDate: String?
    let createdDate: String
}

// MARK: - ChildInfo

struct ChildInfoDTO: Decodable {
    let id: Int
    let nickname: String
    let profileUrl: String
}

// MARK: - StampInfo

struct StampInfoDTO: Decodable {
    let id: String
    let stampDesignId: Int
    let missionContent: String
    let createdDate: String
}

// MARK: - MissionRequestList

struct MissionRequestDTO: Decodable {
    let id: Int
    let missionId: Int
    let missionContent: String
    let createdDate: String
}

// MARK: - Mission

struct MissionDTO: Decodable {
    let id: Int
    let content: String
}
