//
//  LinkManagementMapper.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/03.
//

import Foundation

struct LinkManagementMapper {
    private func mapBaseResponse<T, U>(from dto: BaseResponseDTO<T>, transform: (T) -> U) -> BaseResponse<U> {
        let transformedData = dto.data.map(transform)
        return BaseResponse(status: .success, code: dto.code, messages: dto.messages, data: transformedData)
    }
    
    func mapEmptyDataResponse(from response: BaseResponseDTO<EmptyDataResponseDTO>) -> BaseResponse<EmptyDataResponse> {
        return BaseResponse(status: .success, code: response.code, messages: response.messages, data: nil)
    }
    
    func mapCheckLinkRequestResponse(from response: BaseResponseDTO<CheckLinkRequestDTO>) -> BaseResponse<CheckLinkRequest> {
        return mapBaseResponse(from: response, transform: mapCheckLinkRequest)
    }
    
    private func mapCheckLinkRequest(from dto: CheckLinkRequestDTO) -> CheckLinkRequest {
        return CheckLinkRequest(
            isFamilyReceived: dto.isFamilyReceived,
            isFamilySent: dto.isFamilySent
        )
    }
    
    func mapFamilyMemberResponse(from response: BaseResponseDTO<FamilyMemberDTO>) -> BaseResponse<FamilyMember> {
        return mapBaseResponse(from: response, transform: mapFamilyMember)
    }
    
    func mapFamilyMemberListResponse(from response: BaseResponseDTO<FamilyMemberListDTO>) -> BaseResponse<[FamilyMember]> {
        return mapBaseResponse(from: response, transform: mapFamilyMemberList)
    }
    
    private func mapFamilyMember(_ dto: FamilyMemberDTO) -> FamilyMember {
        return FamilyMember(
            memberID: dto.memberId,
            nickname: dto.nickname,
            memberType: mapMemberType(dto.memberType),
            profileURL: dto.profileUrl ?? "",
            familyStatus: mapFamilyStatus(dto.familyStatus) ?? nil
        )
    }
    
    private func mapFamilyMemberList(_ dto: FamilyMemberListDTO) -> [FamilyMember] {
        return dto.families.compactMap{mapFamilyMember($0)}
    }
    
    private func mapMemberType(_ dto: MemberTypeDTO?) -> MemberType {
        guard let dto else {
            return MemberType(name: "", detail: "")
        }
        
        return MemberType(name: dto.name, detail: dto.detail )
    }
    
    private func mapFamilyStatus(_ statusString: String?) -> FamilyStatus? {
        guard let statusString = statusString else { return nil }
        return FamilyStatus(rawValue: statusString)
    }
}
