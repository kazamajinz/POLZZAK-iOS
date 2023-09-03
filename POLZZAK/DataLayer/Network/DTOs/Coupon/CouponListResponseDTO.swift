//
//  CouponListResponseDTO.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/30.
//

import Foundation

struct CouponListResponseDTO: Decodable {
    let family: FamilyMemberDTO
    let coupons: [CouponDTO]
}

struct CouponDTO: Decodable, Hashable {
    let couponID: Int
    let reward: String
    let rewardRequestDate: String
    let rewardDate: String
    
    enum CodingKeys: String, CodingKey {
        case couponID = "couponId"
        case reward
        case rewardRequestDate
        case rewardDate
    }
}

//extension CouponListResponseDTO {
//    static let sampleData: [CouponListData] = [
//        CouponListData(
//            family: FamilyMember(memberId: 10, nickName: "아름다운 엄마", memberType: MemberType(name: "GUARDIAN", detail: "엄마"), profileURL: "profileUrl", familyStatus: nil),
//            coupons: []
//        ),
//        CouponListData(
//            family: FamilyMember(memberId: 20, nickName: "지혜로운 아빠", memberType: MemberType(name: "GUARDIAN", detail: "아빠"), profileURL: "profileUrl", familyStatus: nil),
//            coupons: [
//                Coupon(couponID: 10, reward: "안마안마안마안마안마안마안마안마안마안마안마안마안마안마안마안마안마 안마권", rewardRequestDate: getDate(daysAfter: 1), rewardDate: getDate(daysAfter: 2)),
//                Coupon(couponID: 20, reward: "안마권", rewardRequestDate: getDate(daysAfter: 1), rewardDate: getDate(daysAfter: 2)),
//                Coupon(couponID: 30, reward: "커피쿠폰", rewardRequestDate: getDate(daysAfter: 1), rewardDate: getDate(daysAfter: 2))
//            ]
//        ),
//        CouponListData(
//            family: FamilyMember(memberId: 30, nickName: "사랑스러운 누나", memberType: MemberType(name: "SIBLING", detail: "누나"), profileURL: "profileUrl", familyStatus: nil),
//            coupons: []
//        ),
//        CouponListData(
//            family: FamilyMember(memberId: 40, nickName: "따뜻한 오빠", memberType: MemberType(name: "SIBLING", detail: "오빠"), profileURL: "profileUrl", familyStatus: nil),
//            coupons: []
//        ),
//        CouponListData(
//            family: FamilyMember(memberId: 50, nickName: "위트있는 할아버지", memberType: MemberType(name: "GRANDFATHER", detail: "할아버지"), profileURL: "profileUrl", familyStatus: nil),
//            coupons: []
//        ),
//        CouponListData(
//            family: FamilyMember(memberId: 60, nickName: "지루한 삼촌", memberType: MemberType(name: "UNCLE", detail: "삼촌"), profileURL: "profileUrl", familyStatus: nil),
//            coupons: []
//        )
//    ]
//
//    static let sampleData2: [CouponListData] = [
//        CouponListData(
//            family: FamilyMember(memberId: 18, nickName: "아름다운 엄마", memberType: MemberType(name: "GUARDIAN", detail: "엄마"), profileURL: "profileUrl", familyStatus: nil),
//            coupons: []
//        ),
//        CouponListData(
//            family: FamilyMember(memberId: 17, nickName: "지혜로운 아빠", memberType: MemberType(name: "GUARDIAN", detail: "아빠"), profileURL: "profileUrl", familyStatus: nil),
//            coupons: [
//                Coupon(couponID: 40, reward: "피자스쿨 쿠폰", rewardRequestDate: getDate(daysAfter: 1), rewardDate: getDate(daysAfter: 7)),
//                Coupon(couponID: 50, reward: "도미노피자 쿠폰", rewardRequestDate: getDate(daysAfter: 1), rewardDate: getDate(daysAfter: 7))
//            ]
//        ),
//        CouponListData(
//            family: FamilyMember(memberId: 19, nickName: "사랑스러운 누나", memberType: MemberType(name: "SIBLING", detail: "누나"), profileURL: "profileUrl", familyStatus: nil),
//            coupons: []
//        ),
//        CouponListData(
//            family: FamilyMember(memberId: 13, nickName: "따뜻한 오빠", memberType: MemberType(name: "SIBLING", detail: "오빠"), profileURL: "profileUrl", familyStatus: nil),
//            coupons: []
//        ),
//        CouponListData(
//            family: FamilyMember(memberId: 16, nickName: "위트있는 할아버지", memberType: MemberType(name: "GRANDFATHER", detail: "할아버지"), profileURL: "profileUrl", familyStatus: nil),
//            coupons: []
//        ),
//        CouponListData(
//            family: FamilyMember(memberId: 12, nickName: "지루한 삼촌", memberType: MemberType(name: "UNCLE", detail: "삼촌"), profileURL: "profileUrl", familyStatus: nil),
//            coupons: []
//        )
//    ]
//
//    static let sampleData3: [CouponListData] = []
//
//    static func getDate(daysAfter: Int) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS"
//        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
//
//        let calendar = Calendar.current
//        let date = calendar.date(byAdding: .day, value: daysAfter, to: Date())!
//
//        return dateFormatter.string(from: date)
//    }
//}
