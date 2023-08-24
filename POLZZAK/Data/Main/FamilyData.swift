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
