//
//  CouponList.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/30.
//

import Foundation

struct CouponList {
    let family: FamilyMember
    let coupons: [Coupon]
}

struct Coupon {
    let couponID: Int
    let reward: String
    let rewardRequestDate: String?
    let rewardDate: String
}
