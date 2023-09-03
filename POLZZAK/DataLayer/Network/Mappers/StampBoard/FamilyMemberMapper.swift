//
//  FamilyMemberMapper.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/30.
//

import Foundation

struct FamilyMemberMapper {
    func map(from response: BaseResponseDTO<FamilyMemberResponseDTO>) -> [FamilyMember] {
        return response.data?.families.compactMap { compactMap(from: $0) } ?? []
    }
    
    func map(from response: BaseResponseDTO<FamilyMemberDTO?>) -> FamilyMember? {
        guard let data = response.data else {
            return nil
        }
        
        return map(from: data)
    }
    
    func map(from dto: FamilyMemberDTO?) -> FamilyMember? {
        guard let dto else {
            return nil
        }
        
        return FamilyMember(
            memberID: dto.memberId,
            nickname: dto.nickname,
            memberType: map(from: dto.memberType),
            profileURL: dto.profileUrl,
            familyStatus: map(from: dto.familyStatus) ?? nil
        )
    }
    
    func compactMap(from dto: FamilyMemberDTO) -> FamilyMember {
        return FamilyMember(
            memberID: dto.memberId,
            nickname: dto.nickname,
            memberType: map(from: dto.memberType),
            profileURL: dto.profileUrl,
            familyStatus: map(from: dto.familyStatus) ?? nil
        )
    }
    
    func map(from dto: MemberTypeDTO) -> MemberType {
        return MemberType(
            name: dto.name,
            detail: dto.detail
        )
    }
    
    func map(from statusString: String?) -> FamilyStatus? {
        guard let statusString = statusString else { return nil }
        return FamilyStatus(rawValue: statusString)
    }
}
