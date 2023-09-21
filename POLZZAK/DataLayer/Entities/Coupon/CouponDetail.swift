//
//  CouponDetail.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/09.
//

import Foundation

struct CouponDetail: Equatable {
    let couponID: Int
    let reward: String
    let guardian: Guardian
    let kid: Guardian
    let missionContents: [String]
    let stampCount: Int
    var couponState: CouponState?
    let rewardDate: String
    let rewardRequestDate: String?
    let startDate: String
    let endDate: String
}
