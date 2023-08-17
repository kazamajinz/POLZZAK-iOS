//
//  CouponDetail.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/17.
//

import Foundation

struct CouponDetail: Codable {
    let couponID: Int
    let reward: String
    let guardian: Guardian
    let kid: Guardian
    let missionContents: [String]
    let stampCount: Int
    let state: String
    let rewardRequestDate: String
    let startDate: String
    let endDate: String
    
    enum CodingKeys: String, CodingKey {
        case couponID = "couponId"
        case reward, guardian, kid, missionContents, stampCount, state, rewardRequestDate, startDate, endDate
    }
}

// MARK: - Guardian
struct Guardian: Codable {
    let nickname, profileURL: String
    
    enum CodingKeys: String, CodingKey {
        case nickname
        case profileURL = "profileUrl"
    }
}

extension CouponDetail {
    static let sampleData: CouponDetail =
    CouponDetail(couponID: 1,
                 reward: "상상상",
                 guardian: Guardian(nickname: "보호자",
                                    profileURL: "https://as1.ftcdn.net/v2/jpg/02/16/27/30/1000_F_216273016_EBLZScZQ5Zu5Yw7W3RO48bdYbsynnjur.jpg"),
                 kid: Guardian(nickname: "아이", profileURL: "https://as1.ftcdn.net/v2/jpg/02/16/27/30/1000_F_216273016_EBLZScZQ5Zu5Yw7W3RO48bdYbsynnjur.jpg"),
                 missionContents: [ "미션1", "미션2", "미션3" ],
                 stampCount: 10,
                 state: "ISSUED",
                 rewardRequestDate: "2023-08-03T11:08:25.030587692",
                 startDate: "2023-08-03T13:08:25.030612893",
                 endDate: "2023-08-03T13:08:25.030623693")
}
