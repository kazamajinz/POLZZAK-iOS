//
//  testData.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/05/28.
//

import Foundation
//TODO: - 테스트 코드, 메인데이터

let dummyUserInformations = (1...5).map { i -> UserInformation in
    UserInformation(
        familyMember: FamilyMember(
            memberId: i,
            nickName: "해린맘\(i)",
            memberType: MemberType(name: "KID", detail: "아이"),
            profileURL: "https://as1.ftcdn.net/v2/jpg/02/16/27/30/1000_F_216273016_EBLZScZQ5Zu5Yw7W3RO48bdYbsynnjur.jpg", familyStatus: nil
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

let tempDummyData = [UserInformation(familyMember: FamilyMember(memberId: 0,
                                                                nickName: "이정환",
                                                                memberType: MemberType(name: "KID", detail: "아이"),
                                                                profileURL: "https://as1.ftcdn.net/v2/jpg/02/16/27/30/1000_F_216273016_EBLZScZQ5Zu5Yw7W3RO48bdYbsynnjur.jpg", familyStatus: nil),
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
                     
                     UserInformation(familyMember: FamilyMember(memberId: 0,
                                                                nickName: "김홍근",
                                                                memberType: MemberType(name: "KID2", detail: "아이"),
                                                                profileURL: "http://polzzak.s3.ap-northeast-2.amazonaws.com/profile/81e05244-a040-436d-9608-319861ea2e51.png", familyStatus: nil),
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
                     
                     UserInformation(familyMember: FamilyMember(memberId: 0,
                                                                nickName: "조준모",
                                                                memberType: MemberType(name: "KID3", detail: "사촌"),
                                                                profileURL: "http://polzzak.s3.ap-northeast-2.amazonaws.com/profile/81e05244-a040-436d-9608-319861ea2e51.png", familyStatus: nil),
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


//TODO: - 테스트 코드, 연동관리데이터

let dummyFmailyData = FamilyData(
    families:
        [
            FamilyMember(memberId: 0, nickName: "이정환", memberType: MemberType(name: "KID", detail: "아이"), profileURL: "https://as1.ftcdn.net/v2/jpg/02/16/27/30/1000_F_216273016_EBLZScZQ5Zu5Yw7W3RO48bdYbsynnjur.jpg", familyStatus: nil),
            FamilyMember(memberId: 1, nickName: "김홍근", memberType: MemberType(name: "KID", detail: "아이"), profileURL: "https://as1.ftcdn.net/v2/jpg/02/16/27/30/1000_F_216273005_rl8P3MYE1xQHXdcCX0cCRFk1Hsvip9ZX.jpg", familyStatus: nil),
            FamilyMember(memberId: 2, nickName: "조준모", memberType: MemberType(name: "KID", detail: "아이"), profileURL: "https://www.shutterstock.com/image-vector/skull-bone-16x16-pixel-art-600w-1113310772.jpg", familyStatus: nil),
            FamilyMember(memberId: 3, nickName: "다람쥐", memberType: MemberType(name: "KID", detail: "아이"), profileURL: "https://d2v80xjmx68n4w.cloudfront.net/gigs/bS1Dr1680424865.jpg", familyStatus: nil),
            FamilyMember(memberId: 4, nickName: "고구마", memberType: MemberType(name: "KID", detail: "아이"), profileURL: "", familyStatus: nil),
            FamilyMember(memberId: 5, nickName: "기린", memberType: MemberType(name: "KID", detail: "아이"), profileURL: "", familyStatus: nil),
            FamilyMember(memberId: 6, nickName: "해바라기", memberType: MemberType(name: "KID", detail: "아이"), profileURL: "", familyStatus: nil),
            FamilyMember(memberId: 7, nickName: "사탕", memberType: MemberType(name: "KID", detail: "아이"), profileURL: "", familyStatus: nil),
            FamilyMember(memberId: 8, nickName: "이정환2", memberType: MemberType(name: "KID", detail: "아이"), profileURL: "https://as1.ftcdn.net/v2/jpg/02/16/27/30/1000_F_216273016_EBLZScZQ5Zu5Yw7W3RO48bdYbsynnjur.jpg", familyStatus: nil),
            FamilyMember(memberId: 9, nickName: "김홍근2", memberType: MemberType(name: "KID", detail: "아이"), profileURL: "https://as1.ftcdn.net/v2/jpg/02/16/27/30/1000_F_216273005_rl8P3MYE1xQHXdcCX0cCRFk1Hsvip9ZX.jpg", familyStatus: nil),
            FamilyMember(memberId: 10, nickName: "조준모2", memberType: MemberType(name: "KID", detail: "아이"), profileURL: "https://www.shutterstock.com/image-vector/skull-bone-16x16-pixel-art-600w-1113310772.jpg", familyStatus: nil),
            FamilyMember(memberId: 11, nickName: "다람쥐2", memberType: MemberType(name: "KID", detail: "아이"), profileURL: "https://d2v80xjmx68n4w.cloudfront.net/gigs/bS1Dr1680424865.jpg", familyStatus: nil),
            FamilyMember(memberId: 12, nickName: "고구마2", memberType: MemberType(name: "KID", detail: "아이"), profileURL: "", familyStatus: nil),
            FamilyMember(memberId: 13, nickName: "기린2", memberType: MemberType(name: "KID", detail: "아이"), profileURL: "", familyStatus: nil),
            FamilyMember(memberId: 14, nickName: "해바라기2", memberType: MemberType(name: "KID", detail: "아이"), profileURL: "", familyStatus: nil),
            FamilyMember(memberId: 15, nickName: "사탕2", memberType: MemberType(name: "KID", detail: "아이"), profileURL: "", familyStatus: nil)
        ]
)


