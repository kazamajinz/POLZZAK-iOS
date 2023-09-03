//
//  FamilyMember.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/30.
//

import Foundation

struct FamilyMember {
    let memberID: Int
    let nickname: String
    let memberType: MemberType
    let profileURL: String
    let familyStatus: FamilyStatus?
}

enum FamilyStatus: String {
    case none = "NONE"
    case received = "RECEIVED"
    case sent = "SENT"
    case approve = "APPROVE"
}
