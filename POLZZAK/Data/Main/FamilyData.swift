//
//  FamilyData.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/14.
//

import Foundation

struct FamilyData: Decodable {
    let families: [FamilyMember]
}

struct FamilyMember: Decodable {
    let memberId: Int
    let nickName: String
    let memberType: MemberType
    let profileURL: String
    let familyStatus: FamilyStatus?

        enum FamilyStatus: String, Decodable {
            case none = "NONE"
            case received = "RECEIVED"
            case sent = "SENT"
            case approve = "APPROVE"
        }
}

extension FamilyMember: Equatable {
    static func == (lhs: FamilyMember, rhs: FamilyMember) -> Bool {
        return lhs.memberId == rhs.memberId
    }
}

extension FamilyData {
    static let sampleData = FamilyData(
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
}
