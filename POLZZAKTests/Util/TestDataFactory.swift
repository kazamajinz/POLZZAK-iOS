//
//  TestDataFactory.swift
//  POLZZAKTests
//
//  Created by 이정환 on 2023/09/21.
//

@testable import POLZZAK
import Foundation

struct TestDataFactory {
    static func makeSampleMemberType() -> MemberType {
        return MemberType(name: "GUARDIAN", detail: "누나")
    }
    
    static func makeSampleFamilyMember() -> FamilyMember {
        return FamilyMember(
            memberID: 18,
            nickname: "누나",
            memberType: makeSampleMemberType(),
            profileURL: "http://polzzak.s3.ap-northeast-2.amazonaws.com/profile/default_profile.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20230919T155753Z&X-Amz-SignedHeaders=host&X-Amz-Expires=60&X-Amz-Credential=AKIA24ZYI3CQGEVEKZFA%2F20230919%2Fap-northeast-2%2Fs3%2Faws4_request&X-Amz-Signature=8b6a56de510fb4542913a66c4329df0ca174899d9afc71881f11c6c8be6728c2",
            familyStatus: nil
        )
    }
    
    static func makeSampleStampBoardSummary() -> StampBoardSummary {
        return StampBoardSummary(
            stampBoardId: 11,
            name: "213",
            currentStampCount: 10,
            goalStampCount: 10,
            reward: "123",
            missionRequestCount: 0,
            status: .issuedCoupon
        )
    }

    static func makeSampleStampBoardList() -> [StampBoardList] {
        return [StampBoardList(
            family: makeSampleFamilyMember(),
            stampBoardSummaries: [makeSampleStampBoardSummary()]
        )]
    }
    
    static func makeSampleSerchForUserName() -> FamilyMember? {
        return FamilyMember(
            memberID: 18,
            nickname: "누나",
            memberType: makeSampleMemberType(),
            profileURL: "http://polzzak.s3.ap-northeast-2.amazonaws.com/profile/default_profile.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20230919T155753Z&X-Amz-SignedHeaders=host&X-Amz-Expires=60&X-Amz-Credential=AKIA24ZYI3CQGEVEKZFA%2F20230919%2Fap-northeast-2%2Fs3%2Faws4_request&X-Amz-Signature=8b6a56de510fb4542913a66c4329df0ca174899d9afc71881f11c6c8be6728c2",
            familyStatus: FamilyStatus.none
        )
    }
    
    static func makeSampleLinkMagementList() -> [FamilyMember] {
        return [makeSampleFamilyMember()]
    }
    
    static func makeSample201EmptyData() -> EmptyDataResponse {
        return EmptyDataResponse(code: 201, messages: nil)
    }
    
    static func makeSampleNewRequestData() -> CheckLinkRequest? {
        return CheckLinkRequest(isFamilyReceived: true, isFamilySent: false)
    }
    
    static func makeSampleCoupons() -> [Coupon] {
        return [Coupon(
            couponID: 5,
            reward: "123", rewardRequestDate: nil,
            rewardDate: "2023-09-17T08:17:50"
        )]
    }
    
    static func makeSampleCouponListData() -> [CouponList] {
        return [CouponList(
            family: makeSampleFamilyMember(),
            coupons: makeSampleCoupons())
        ]
    }
    
    static func makeSampleGuardianData() -> Guardian {
        return Guardian(nickname: "보호자", profileURL: "http://polzzak.s3.ap-northeast-2.amazonaws.com/profile/default_profile.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20230914T155221Z&X-Amz-SignedHeaders=host&X-Amz-Expires=59&X-Amz-Credential=AKIA24ZYI3CQGEVEKZFA%2F20230914%2Fap-northeast-2%2Fs3%2Faws4_request&X-Amz-Signature=a00554c657539a36bc42f6fa7c573c784e78a893373a7bcffb7df097f78a9b65")
    }
    
    static func makeSampleKidData() -> Guardian {
        return Guardian(nickname: "아이", profileURL: "http://polzzak.s3.ap-northeast-2.amazonaws.com/profile/default_profile.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20230914T155221Z&X-Amz-SignedHeaders=host&X-Amz-Expires=59&X-Amz-Credential=AKIA24ZYI3CQGEVEKZFA%2F20230914%2Fap-northeast-2%2Fs3%2Faws4_request&X-Amz-Signature=a00554c657539a36bc42f6fa7c573c784e78a893373a7bcffb7df097f78a9b65")
    }
    
    static func makeSampleCouponDetailData() -> CouponDetail {
        return CouponDetail(
            couponID: 15,
            reward: "안녕",
            guardian: makeSampleGuardianData(),
            kid: makeSampleKidData(),
            missionContents: [],
            stampCount: 10,
            couponState: .rewarded,
            rewardDate: "2023-09-08T15:35:52",
            rewardRequestDate: nil,
            startDate: "2023-09-08T14:15:31",
            endDate: "2023-09-08T14:16:24"
        )
    }
    
    static func makeSampleSender() -> Sender {
        return Sender(
            id: 18,
            nickname: "누나",
            profileURL: "http://polzzak.s3.ap-northeast-2.amazonaws.com/profile/default_profile.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20230919T105522Z&X-Amz-SignedHeaders=host&X-Amz-Expires=60&X-Amz-Credential=AKIA24ZYI3CQGEVEKZFA%2F20230919%2Fap-northeast-2%2Fs3%2Faws4_request&X-Amz-Signature=02c9d35a5e306b0596ab539dd965a6186e2632be0304ad50fea17efd255f7912"
        )
    }
    
    static func makeSampleNotification() -> [NotificationData] {
        return [NotificationData(
            id: 45,
            type: .createStampBoard,
            status: .read,
            title: "🥁️️ 새로운 도장판 도착",
            message: "'<b>sdf</b>' 도장판이 만들어졌어요. 미션 수행 시~작!",
            sender: makeSampleSender(),
            link: .stampBoard(stampBoardID: 20),
            requestFamilyID: nil,
            createdDate: "2023-09-19T08:46:42"
        )]
    }
    
    static func makSampleNotificationListData() -> NotificationResponse {
        return NotificationResponse(
            startID: 17,
            notificationList: makeSampleNotification())
    }
}
