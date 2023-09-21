//
//  StampBoardListDTO.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/30.
//

import Foundation

struct StampBoardListDTO: Decodable {
    let partner: FamilyMemberDTO
    let stampBoardSummaries: [StampBoardSummaryDTO]
}

struct StampBoardSummaryDTO: Decodable {
    let stampBoardID: Int
    let name: String
    let currentStampCount: Int
    let goalStampCount: Int
    let reward: String
    let missionRequestCount: Int
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case stampBoardID = "stampBoardId"
        case name, currentStampCount, goalStampCount, reward, missionRequestCount, status
    }
}
