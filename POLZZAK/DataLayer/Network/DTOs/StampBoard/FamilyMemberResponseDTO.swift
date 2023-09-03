//
//  FamilyMemberResponseDTO.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/30.
//

import Foundation

struct FamilyMemberResponseDTO: Decodable {
    let families: [FamilyMemberDTO]
}

struct FamilyMemberDTO: Decodable {
    let memberId: Int
    let nickname: String
    let memberType: MemberTypeDTO
    let profileUrl: String
    let familyStatus: String?
}
