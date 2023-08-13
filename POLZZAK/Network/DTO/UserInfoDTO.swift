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
        let memberType: MemberType
        let profileUrl: String
        let familyCount: Int
        
        func asUserInfoTypeWithoutID() -> UserInfoWithoutID {
            return UserInfoWithoutID(
                nickname: nickname,
                memberPoint: memberPoint,
                memberType: memberType,
                profileUrl: profileUrl,
                familyCount: familyCount
            )
        }
    }
    
    struct UserInfoWithoutID: Codable {
        let nickname: String
        let memberPoint: MemberPoint
        let memberType: MemberType
        let profileUrl: String
        let familyCount: Int
    }
}
