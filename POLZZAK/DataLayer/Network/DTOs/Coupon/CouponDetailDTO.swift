//
//  CouponDetailDTO.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/09.
//

import Foundation

struct CouponDetailDTO: Decodable {
    let couponID: Int
    let reward: String
    let guardian: GuardianDTO
    let kid: GuardianDTO
    let missionContents: [String]
    let stampCount: Int
    let state: String
    let rewardDate: String
    let rewardRequestDate: String?
    let startDate: String
    let endDate: String
    
    enum CodingKeys: String, CodingKey {
        case couponID = "couponId"
        case reward, guardian, kid, missionContents, stampCount, state, rewardDate, rewardRequestDate, startDate, endDate
    }
}
