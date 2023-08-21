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
    static let sampleDatas: [Int : CouponDetail] =
    [10 : CouponDetail(couponID: 10,
                 reward: "안마안마안마안마안마안마안마안마안마안마안마안마안마안마안마안마안마 안마권",
                 guardian: Guardian(nickname: "지혜로운 아빠",
                                    profileURL: "https://d2v80xjmx68n4w.cloudfront.net/gigs/bS1Dr1680424865.jpg"),
                 kid: Guardian(nickname: "아이", profileURL: "https://d2v80xjmx68n4w.cloudfront.net/gigs/bS1Dr1680424865.jpg"),
                       missionContents: [ "미션1", "미션2", "미션3", "미션1", "미션2", "미션3", "미션1", "미션2", "미션3", "미션1", "미션2", "미션3", "미션1", "미션2", "미션3"],
                 stampCount: 10,
                   state: ".inProgress",
                 rewardRequestDate: "2023-08-03T11:08:25.030587692",
                 startDate: "2023-08-03T13:08:25.030612893",
                 endDate: "2023-08-13T13:08:25.030623693"),
     20 : CouponDetail(couponID: 20,
                  reward: "안마권",
                  guardian: Guardian(nickname: "지혜로운 아빠",
                                     profileURL: "https://as1.ftcdn.net/v2/jpg/02/16/27/30/1000_F_216273016_EBLZScZQ5Zu5Yw7W3RO48bdYbsynnjur.jpg"),
                  kid: Guardian(nickname: "아이", profileURL: "https://as1.ftcdn.net/v2/jpg/02/16/27/30/1000_F_216273016_EBLZScZQ5Zu5Yw7W3RO48bdYbsynnjur.jpg"),
                  missionContents: [ "미션1", "미션2", "미션3" ],
                  stampCount: 10,
                  state: ".inProgress",
                  rewardRequestDate: "2023-08-03T11:08:25.030587692",
                  startDate: "2023-08-03T13:08:25.030612893",
                  endDate: "2023-08-03T13:08:25.030623693"),
     30 : CouponDetail(couponID: 30,
                  reward: "커피쿠폰",
                  guardian: Guardian(nickname: "지혜로운 아빠",
                                     profileURL: "https://as1.ftcdn.net/v2/jpg/02/16/27/30/1000_F_216273016_EBLZScZQ5Zu5Yw7W3RO48bdYbsynnjur.jpg"),
                  kid: Guardian(nickname: "아이", profileURL: "https://as1.ftcdn.net/v2/jpg/02/16/27/30/1000_F_216273016_EBLZScZQ5Zu5Yw7W3RO48bdYbsynnjur.jpg"),
                  missionContents: [ "미션1", "미션2", "미션3" ],
                  stampCount: 10,
                       state: ".inProgress",
                  rewardRequestDate: "2023-08-03T11:08:25.030587692",
                  startDate: "2023-08-03T13:08:25.030612893",
                  endDate: "2023-08-03T13:08:25.030623693"),
     40 : CouponDetail(couponID: 1,
                  reward: "피자스쿨 쿠폰",
                  guardian: Guardian(nickname: "지혜로운 아빠",
                                     profileURL: "https://as1.ftcdn.net/v2/jpg/02/16/27/30/1000_F_216273016_EBLZScZQ5Zu5Yw7W3RO48bdYbsynnjur.jpg"),
                  kid: Guardian(nickname: "아이", profileURL: "https://as1.ftcdn.net/v2/jpg/02/16/27/30/1000_F_216273016_EBLZScZQ5Zu5Yw7W3RO48bdYbsynnjur.jpg"),
                  missionContents: [ "미션1", "미션2", "미션3" ],
                  stampCount: 40,
                       state: ".completed",
                  rewardRequestDate: "2023-08-03T11:08:25.030587692",
                  startDate: "2023-08-03T13:08:25.030612893",
                  endDate: "2023-08-03T13:08:25.030623693"),
     50 : CouponDetail(couponID: 1,
                  reward: "도미노피자 쿠폰",
                  guardian: Guardian(nickname: "지혜로운 아빠",
                                     profileURL: "https://as1.ftcdn.net/v2/jpg/02/16/27/30/1000_F_216273016_EBLZScZQ5Zu5Yw7W3RO48bdYbsynnjur.jpg"),
                  kid: Guardian(nickname: "아이", profileURL: "https://as1.ftcdn.net/v2/jpg/02/16/27/30/1000_F_216273016_EBLZScZQ5Zu5Yw7W3RO48bdYbsynnjur.jpg"),
                  missionContents: [ "미션1", "미션2", "미션3" ],
                  stampCount: 40,
                       state: ".completed",
                  rewardRequestDate: "2023-08-03T11:08:25.030587692",
                  startDate: "2023-08-03T13:08:25.030612893",
                  endDate: "2023-08-03T13:08:25.030623693"),
    ]
}
