//
//  testData.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/05/28.
//

import Foundation
//TODO: 테스트 코드, 삭제할것

let dummyUserInformations = (1...5).map { i -> UserInformation in
    UserInformation(
        partner: Partner(
            memberId: i,
            nickname: "해린맘\(i)",
            memberType: MemberType(name: "KID", detail: "아이"),
            profileURL: "http://polzzak.s3.ap-northeast-2.amazonaws.com/profile/81e05244-a040-436d-9608-319861ea2e51.png",
            kid: true
        ),
        stampBoardSummaries: (1...5).map { j -> StampBoardSummary in
            StampBoardSummary(
                stampBoardId: j+7,
                name: "테스트 도장판 \(i) / \(j)",
                currentStampCount: (0...30).randomElement() ?? 0,
                goalStampCount: 30,
                reward: "칭찬 \(j), j % 2 = \(j % 2)",
                missionCompleteCount: (0...30).randomElement() ?? 0,
                isRewarded: j == 5 ? true : false
            )
        }
    )
}

let tempDummyData = [UserInformation(partner: Partner(memberId: 0,
                                                      nickname: "이정환",
                                                      memberType: MemberType(name: "KID", detail: "아이"),
                                                      profileURL: "http://polzzak.s3.ap-northeast-2.amazonaws.com/profile/81e05244-a040-436d-9608-319861ea2e51.png",
                                                      kid: false),
                                     stampBoardSummaries: [StampBoardSummary(stampBoardId: 0,
                                                                             name: "가루비의 도장판",
                                                                             currentStampCount: 2,
                                                                             goalStampCount: 20,
                                                                             reward: "칭찬",
                                                                             missionCompleteCount: 3,
                                                                             isRewarded: false),
                                                           StampBoardSummary(stampBoardId: 0,
                                                                             name: "빠네의 도장판",
                                                                             currentStampCount: 10,
                                                                             goalStampCount: 10,
                                                                             reward: "맥북",
                                                                             missionCompleteCount: 0,
                                                                             isRewarded: false),
                                                           StampBoardSummary(stampBoardId: 0,
                                                                             name: "이정환의 도장판",
                                                                             currentStampCount: 2,
                                                                             goalStampCount: 4,
                                                                             reward: "도서상품권",
                                                                             missionCompleteCount: 2,
                                                                             isRewarded: false)]),
                     
                     UserInformation(partner: Partner(memberId: 0,
                                                      nickname: "김홍근",
                                                      memberType: MemberType(name: "KID2", detail: "아이"),
                                                      profileURL: "http://polzzak.s3.ap-northeast-2.amazonaws.com/profile/81e05244-a040-436d-9608-319861ea2e51.png",
                                                      kid: false),
                                     stampBoardSummaries: [StampBoardSummary(stampBoardId: 0,
                                                                             name: "히도의 도장판",
                                                                             currentStampCount: 5,
                                                                             goalStampCount: 25,
                                                                             reward: "휴가",
                                                                             missionCompleteCount: 1,
                                                                             isRewarded: false),
                                                           StampBoardSummary(stampBoardId: 0,
                                                                             name: "육각이의 도장판",
                                                                             currentStampCount: 1,
                                                                             goalStampCount: 30,
                                                                             reward: "커피",
                                                                             missionCompleteCount: 1,
                                                                             isRewarded: false),
                                                           StampBoardSummary(stampBoardId: 0,
                                                                             name: "방울이의 도장판",
                                                                             currentStampCount: 0,
                                                                             goalStampCount: 5,
                                                                             reward: "안마",
                                                                             missionCompleteCount: 5,
                                                                             isRewarded: false)]),
                     
                     UserInformation(partner: Partner(memberId: 0,
                                                      nickname: "조준모",
                                                      memberType: MemberType(name: "KID3", detail: "사촌"),
                                                      profileURL: "http://polzzak.s3.ap-northeast-2.amazonaws.com/profile/81e05244-a040-436d-9608-319861ea2e51.png",
                                                      kid: false),
                                     stampBoardSummaries: [StampBoardSummary(stampBoardId: 1,
                                                                             name: "준모의 도장판",
                                                                             currentStampCount: 10,
                                                                             goalStampCount: 10,
                                                                             reward: "자전거",
                                                                             missionCompleteCount: 0,
                                                                             isRewarded: false),
                                                           StampBoardSummary(stampBoardId: 1,
                                                                             name: "도라에몽",
                                                                             currentStampCount: 10,
                                                                             goalStampCount: 10,
                                                                             reward: "대나무 핼리콥터",
                                                                             missionCompleteCount: 0,
                                                                             isRewarded: false),
                                                           StampBoardSummary(stampBoardId: 1,
                                                                             name: "짱구의 도장판",
                                                                             currentStampCount: 5,
                                                                             goalStampCount: 5,
                                                                             reward: "초코비",
                                                                             missionCompleteCount: 0,
                                                                             isRewarded: false)])
                     
]
