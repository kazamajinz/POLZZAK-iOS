//
//  CouponListDTO.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/30.
//

import Foundation

struct CouponListDTO: Decodable {
    let family: FamilyMemberDTO
    let coupons: [CouponDTO]
}

struct CouponDTO: Decodable {
    let couponID: Int
    let reward: String
    let rewardRequestDate: String?
    let rewardDate: String
    
    enum CodingKeys: String, CodingKey {
        case couponID = "couponId"
        case reward
        case rewardRequestDate
        case rewardDate
    }
}
