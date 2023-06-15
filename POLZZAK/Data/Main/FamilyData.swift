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
    let nickname: String
    let memberType: MemberType
    let profileURL: String
}
