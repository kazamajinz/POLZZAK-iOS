//
//  StampBoardListResponseDTO.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/30.
//

import Foundation

struct StampBoardListResponseDTO: Decodable {
    let family: FamilyMemberDTO
    let stampBoardSummaries: [StampBoardSummaryDTO]
}

struct StampBoardSummaryDTO: Decodable {
    let stampBoardId: Int
    let name: String
    let currentStampCount: Int
    let goalStampCount: Int
    let reward: String
    let missionCompleteCount: Int
    let isRewarded: Bool
}
