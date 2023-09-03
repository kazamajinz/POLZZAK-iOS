//
//  UserInfoDTO.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/14.
//

import Foundation

struct UserInfoDTO: Codable {
    let code: Int
    let data: UserInfo
}

extension UserInfoDTO {
    struct UserInfo: Codable {
        let memberId: Int
        let nickname: String
        let memberPoint: MemberPoint
        //TODO: - 진영님꼐 말씀드려야함
        let memberType: MemberTypeDTO
        let profileUrl: String
        let familyCount: Int
    }
}
