//
//  UserStampBoardList.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/05/18.
//

import Foundation

struct UserStampBoardList: Decodable {
    let family: FamilyMember
    let stampBoardSummaries: [StampBoardSummary]
}

struct StampBoardSummary: Decodable {
    let stampBoardId: Int
    let name: String
    let currentStampCount: Int
    let goalStampCount: Int
    let reward: String
    let missionCompleteCount: Int
    let isRewarded: Bool
}

extension UserStampBoardList {
    static let sampleData: [UserStampBoardList] = [
        UserStampBoardList(
            family: FamilyMember(memberId: 0,
                                 nickName: "이정환",
                                 memberType: MemberType(name: "삼촌1", detail: "삼촌1"),
                                 profileURL: "https://as1.ftcdn.net/v2/jpg/02/16/27/30/1000_F_216273016_EBLZScZQ5Zu5Yw7W3RO48bdYbsynnjur.jpg", familyStatus: nil),
            stampBoardSummaries: [
                StampBoardSummary(stampBoardId: 0, name: "가루비의 도장판", currentStampCount: 2, goalStampCount: 20, reward: "칭찬", missionCompleteCount: 3, isRewarded: false),
                StampBoardSummary(stampBoardId: 0, name: "빠네의 도장판", currentStampCount: 10, goalStampCount: 10, reward: "맥북", missionCompleteCount: 0, isRewarded: false),
                StampBoardSummary(stampBoardId: 0, name: "이정환의 도장판", currentStampCount: 2, goalStampCount: 4, reward: "도서상품권", missionCompleteCount: 2, isRewarded: false)
            ]
        ),
        
        UserStampBoardList(
            family: FamilyMember(memberId: 0,
                                 nickName: "김홍근",
                                 memberType: MemberType(name: "삼촌2", detail: "삼촌2"),
                                 profileURL: "http://polzzak.s3.ap-northeast-2.amazonaws.com/profile/81e05244-a040-436d-9608-319861ea2e51.png", familyStatus: nil),
            stampBoardSummaries: [
                StampBoardSummary(stampBoardId: 0, name: "히도의 도장판", currentStampCount: 5, goalStampCount: 25, reward: "휴가", missionCompleteCount: 1, isRewarded: false),
                StampBoardSummary(stampBoardId: 0, name: "육각이의 도장판", currentStampCount: 1, goalStampCount: 30, reward: "커피", missionCompleteCount: 1, isRewarded: false),
                StampBoardSummary(stampBoardId: 0, name: "방울이의 도장판", currentStampCount: 0, goalStampCount: 5, reward: "안마", missionCompleteCount: 5, isRewarded: false)
            ]
        ),
        
        UserStampBoardList(
            family: FamilyMember(memberId: 0,
                                 nickName: "조준모",
                                 memberType: MemberType(name: "삼촌3", detail: "삼촌3"),
                                 profileURL: "http://polzzak.s3.ap-northeast-2.amazonaws.com/profile/81e05244-a040-436d-9608-319861ea2e51.png", familyStatus: nil),
            stampBoardSummaries: [
                StampBoardSummary(stampBoardId: 1, name: "준모의 도장판", currentStampCount: 10, goalStampCount: 10, reward: "자전거", missionCompleteCount: 0, isRewarded: false),
                StampBoardSummary(stampBoardId: 1, name: "도라에몽", currentStampCount: 10, goalStampCount: 10, reward: "대나무 핼리콥터", missionCompleteCount: 0, isRewarded: false),
                StampBoardSummary(stampBoardId: 1, name: "짱구의 도장판", currentStampCount: 5, goalStampCount: 5, reward: "초코비", missionCompleteCount: 0, isRewarded: false)
            ]
        )
    ]
    
    static let sampleData3: [UserStampBoardList] = []
}
