//
//  FamilyMemberListDTO.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/30.
//

import Foundation

struct FamilyMemberListDTO: Decodable {
    let families: [FamilyMemberDTO]
}

struct FamilyMemberDTO: Decodable {
    let memberID: Int
    let nickname: String
    let memberType: MemberTypeDTO
    let profileURL: String?
    let familyStatus: String?
    
    enum CodingKeys: String, CodingKey {
        case memberID = "memberId"
        case profileURL = "profileUrl"
        case nickname, memberType, familyStatus
    }
}
