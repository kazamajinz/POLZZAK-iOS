//
//  StampBoardsMapper.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/30.
//

import Foundation

struct StampBoardsMapper: MappableResponse {
    func mapStampBoardListResponse(from response: BaseResponseDTO<[StampBoardListDTO]>) -> BaseResponse<[StampBoardList]> {
        return mapBaseResponse(from: response, transform: mapStampBoardList)
    }
    
    private func mapStampBoardList(_ dto: [StampBoardListDTO]) -> [StampBoardList] {
        return dto.map{
            StampBoardList(
                family: mapFamilyMember($0.partner),
                stampBoardSummaries: mapStampBoardSummaries($0.stampBoardSummaries)
            )
        }
    }
    
    private func mapFamilyMember(_ dto: FamilyMemberDTO) -> FamilyMember {
        return FamilyMember(
            memberID: dto.memberID,
            nickname: dto.nickname,
            memberType: mapMemberType(from: dto.memberType),
            profileURL: dto.profileURL ?? "",
            familyStatus: nil
        )
    }
    
    private func mapMemberType(from dto: MemberTypeDTO) -> MemberType {
        return MemberType(
            name: dto.name,
            detail: dto.detail
        )
    }
    
    private func mapStampBoardSummary(_ dto: StampBoardSummaryDTO) -> StampBoardSummary {
        return StampBoardSummary(
            stampBoardId: dto.stampBoardID,
            name: dto.name,
            currentStampCount: dto.currentStampCount,
            goalStampCount: dto.goalStampCount,
            reward: dto.reward,
            missionRequestCount: dto.missionRequestCount,
            status: mapStampBoardStatus(dto.status)
        )
    }
    
    private func mapStampBoardStatus(_ statusString: String?) -> StampBoardStatus? {
        guard let statusString = statusString else { return nil }
        return StampBoardStatus(rawValue: statusString)
    }
    
    private func mapStampBoardSummaries(_ dto: [StampBoardSummaryDTO]) -> [StampBoardSummary] {
        return dto.compactMap { mapStampBoardSummary($0) }
    }
}
