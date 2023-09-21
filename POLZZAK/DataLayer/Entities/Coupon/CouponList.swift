//
//  CouponList.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/30.
//

import Foundation

struct CouponList: Equatable {
    let family: FamilyMember
    var coupons: [Coupon]
}

struct Coupon: Equatable {
    let couponID: Int
    let reward: String
    let rewardRequestDate: String?
    let rewardDate: String
}
