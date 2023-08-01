//
//  CouponListData.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/07/28.
//

import Foundation

struct CouponListData: Decodable {
    let family: FamilyMember
    let coupons: [Coupon]
}

struct Coupon: Decodable, Hashable {
    let couponID: Int
    let reward: String
    let rewardRequestDate: String
    let rewardDate: String
    
    enum CodingKeys: String, CodingKey {
        case couponID = "couponId"
        case reward, rewardRequestDate, rewardDate
    }
}

extension CouponListData {
    static let sampleData: [CouponListData] = [
            CouponListData(
                family: FamilyMember(memberId: 0, nickName: "아름다운 엄마", memberType: MemberType(name: "GUARDIAN", detail: "엄마"), profileURL: "profileUrl", familyStatus: nil),
                coupons: [
                    Coupon(couponID: 0, reward: "안마권", rewardRequestDate: getDate(daysAgo: 1), rewardDate: getDate(daysAgo: 2))
                ]
            ),
            CouponListData(
                family: FamilyMember(memberId: 1, nickName: "지혜로운 아빠", memberType: MemberType(name: "GUARDIAN", detail: "아빠"), profileURL: "profileUrl", familyStatus: nil),
                coupons: [
                    Coupon(couponID: 1, reward: "커피 무료 쿠폰", rewardRequestDate: getDate(daysAgo: 2), rewardDate: getDate(daysAgo: 3))
                ]
            ),
            CouponListData(
                family: FamilyMember(memberId: 2, nickName: "사랑스러운 누나", memberType: MemberType(name: "SIBLING", detail: "누나"), profileURL: "profileUrl", familyStatus: nil),
                coupons: [
                    Coupon(couponID: 2, reward: "영화 티켓", rewardRequestDate: getDate(daysAgo: 3), rewardDate: getDate(daysAgo: 5))
                ]
            ),
            CouponListData(
                family: FamilyMember(memberId: 3, nickName: "따뜻한 오빠", memberType: MemberType(name: "SIBLING", detail: "오빠"), profileURL: "profileUrl", familyStatus: nil),
                coupons: [
                    Coupon(couponID: 3, reward: "음식 쿠폰", rewardRequestDate: getDate(daysAgo: 4), rewardDate: getDate(daysAgo: 6))
                ]
            ),
            CouponListData(
                family: FamilyMember(memberId: 4, nickName: "재미있는 삼촌", memberType: MemberType(name: "UNCLE", detail: "삼촌"), profileURL: "profileUrl", familyStatus: nil),
                coupons: [
                    Coupon(couponID: 4, reward: "피자 쿠폰", rewardRequestDate: getDate(daysAgo: 1), rewardDate: getDate(daysAgo: 7))
                ]
            )
        ]
        
        static func getDate(daysAgo: Int) -> String {
            let formatter = ISO8601DateFormatter()
            let calendar = Calendar.current
            let date = calendar.date(byAdding: .day, value: -daysAgo, to: Date())!
            return formatter.string(from: date)
        }}
