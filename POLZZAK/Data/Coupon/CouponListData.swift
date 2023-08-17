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
            family: FamilyMember(memberId: 18, nickName: "아름다운 엄마", memberType: MemberType(name: "GUARDIAN", detail: "엄마"), profileURL: "profileUrl", familyStatus: nil),
            coupons: []
        ),
        CouponListData(
            family: FamilyMember(memberId: 17, nickName: "지혜로운 아빠", memberType: MemberType(name: "GUARDIAN", detail: "아빠"), profileURL: "profileUrl", familyStatus: nil),
            coupons: []
        ),
        CouponListData(
            family: FamilyMember(memberId: 19, nickName: "사랑스러운 누나", memberType: MemberType(name: "SIBLING", detail: "누나"), profileURL: "profileUrl", familyStatus: nil),
            coupons: []
        ),
        CouponListData(
            family: FamilyMember(memberId: 13, nickName: "따뜻한 오빠", memberType: MemberType(name: "SIBLING", detail: "오빠"), profileURL: "profileUrl", familyStatus: nil),
            coupons: []
        ),
        CouponListData(
            family: FamilyMember(memberId: 16, nickName: "위트있는 할아버지", memberType: MemberType(name: "GRANDFATHER", detail: "할아버지"), profileURL: "profileUrl", familyStatus: nil),
            coupons: []
        ),
        CouponListData(
            family: FamilyMember(memberId: 12, nickName: "지루한 삼촌", memberType: MemberType(name: "UNCLE", detail: "삼촌"), profileURL: "profileUrl", familyStatus: nil),
            coupons: [
                Coupon(couponID: 12, reward: "안마안마안마안마안마안마안마안마안마안마안마안마안마안마안마안마안마 안마권", rewardRequestDate: getDate(daysAfter: 1), rewardDate: getDate(daysAfter: 2)),
                Coupon(couponID: 13, reward: "안마권", rewardRequestDate: getDate(daysAfter: 1), rewardDate: getDate(daysAfter: 2)),
                Coupon(couponID: 14, reward: "안마권", rewardRequestDate: getDate(daysAfter: 1), rewardDate: getDate(daysAfter: 2)),
                Coupon(couponID: 45, reward: "피자 쿠폰", rewardRequestDate: getDate(daysAfter: 1), rewardDate: getDate(daysAfter: 7)),
                Coupon(couponID: 42, reward: "피자 쿠폰", rewardRequestDate: getDate(daysAfter: 1), rewardDate: getDate(daysAfter: 7))
            ]
        )
    ]
    
    static let sampleData2: [CouponListData] = [
        CouponListData(
            family: FamilyMember(memberId: 18, nickName: "아름다운 엄마", memberType: MemberType(name: "GUARDIAN", detail: "엄마"), profileURL: "profileUrl", familyStatus: nil),
            coupons: [
                Coupon(couponID: 20, reward: "안마안마안마안마안마안마안마안마안마안마안마안마안마안마안마안마안마 안마권", rewardRequestDate: getDate(daysAfter: 1), rewardDate: getDate(daysAfter: 2)),
                Coupon(couponID: 30, reward: "안마권", rewardRequestDate: getDate(daysAfter: 1), rewardDate: getDate(daysAfter: 2)),
                Coupon(couponID: 40, reward: "안마권", rewardRequestDate: getDate(daysAfter: 1), rewardDate: getDate(daysAfter: 2)),
                Coupon(couponID: 54, reward: "피자 쿠폰", rewardRequestDate: getDate(daysAfter: 1), rewardDate: getDate(daysAfter: 7)),
                Coupon(couponID: 64, reward: "피자 쿠폰", rewardRequestDate: getDate(daysAfter: 1), rewardDate: getDate(daysAfter: 7))
            ]
        ),
        CouponListData(
            family: FamilyMember(memberId: 17, nickName: "지혜로운 아빠", memberType: MemberType(name: "GUARDIAN", detail: "아빠"), profileURL: "profileUrl", familyStatus: nil),
            coupons: []
        ),
        CouponListData(
            family: FamilyMember(memberId: 19, nickName: "사랑스러운 누나", memberType: MemberType(name: "SIBLING", detail: "누나"), profileURL: "profileUrl", familyStatus: nil),
            coupons: []
        ),
        CouponListData(
            family: FamilyMember(memberId: 13, nickName: "따뜻한 오빠", memberType: MemberType(name: "SIBLING", detail: "오빠"), profileURL: "profileUrl", familyStatus: nil),
            coupons: []
        ),
        CouponListData(
            family: FamilyMember(memberId: 16, nickName: "위트있는 할아버지", memberType: MemberType(name: "GRANDFATHER", detail: "할아버지"), profileURL: "profileUrl", familyStatus: nil),
            coupons: []
        ),
        CouponListData(
            family: FamilyMember(memberId: 12, nickName: "지루한 삼촌", memberType: MemberType(name: "UNCLE", detail: "삼촌"), profileURL: "profileUrl", familyStatus: nil),
            coupons: []
        )
    ]
    
    static func getDate(daysAfter: Int) -> String {
        let formatter = ISO8601DateFormatter()
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .day, value: daysAfter, to: Date())!
        return formatter.string(from: date)
    }
}
