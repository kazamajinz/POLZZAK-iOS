//
//  LinkManagementDataRepository.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/30.
//

import Foundation

class LinkManagementDataRepository: DataRepositoryProtocol, LinkManagementRepository, LinkRequestRepository {
    typealias MapperType = LinkManagementMapper
    let mapper: MapperType = LinkManagementMapper()
    
    typealias ServiceType = LinkManagementService
    var service: ServiceType
    
    init(linkManagementService: LinkManagementService = LinkManagementService()) {
        self.service = linkManagementService
    }
    
    func getUserByNickname(_ nickname: String) async throws -> NetworkResult<BaseResponse<FamilyMember>, NetworkError> {
        return try await fetchData(
            using: { try await service.fetchUserByNickname(nickname) },
            decodingTo: BaseResponseDTO<FamilyMemberDTO>.self,
            map: { mapper.mapFamilyMemberResponse(from: $0) }
        )
    }
    
    func getLinkedUsers() async throws -> NetworkResult<BaseResponse<[FamilyMember]>, NetworkError> {
        return try await fetchData(
            using: { try await service.fetchAllLinkedUsers() },
            decodingTo: BaseResponseDTO<FamilyMemberListDTO>.self,
            map: { mapper.mapFamilyMemberListResponse(from: $0) }
        )
    }
    
    func getReceivedLinkRequests() async throws -> NetworkResult<BaseResponse<[FamilyMember]>, NetworkError> {
        return try await fetchData(
            using: { try await service.fetchAllReceivedUsers() },
            decodingTo: BaseResponseDTO<FamilyMemberListDTO>.self,
            map: { mapper.mapFamilyMemberListResponse(from: $0) }
        )
    }
    
    func getSentLinkRequests() async throws -> NetworkResult<BaseResponse<[FamilyMember]>, NetworkError> {
        return try await fetchData(
            using: { try await service.fetchAllRequestedUsers() },
            decodingTo: BaseResponseDTO<FamilyMemberListDTO>.self,
            map: { mapper.mapFamilyMemberListResponse(from: $0) }
        )
    }
    
    func createLinkRequest(to memberID: Int) async throws -> NetworkResult<BaseResponse<EmptyDataResponse>, NetworkError> {
        return try await fetchData(
            using: { try await service.sendLinkRequest(to: memberID) },
            decodingTo: BaseResponseDTO<EmptyDataResponseDTO>.self,
            map: { mapper.mapEmptyDataResponse(from: $0) },
            handleStatusCodes: [201]
        )
    }
    
    func deleteSentLinkRequest(to memberID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError> {
        return try await fetchDataNoContent(
            using: { try await service.cancelLinkRequest(to: memberID) }
        )
    }
    
    func approveLinkRequest(to memberID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError> {
        return try await fetchDataNoContent(
            using: { try await service.approveLinkRequest(from: memberID) }
        )
    }
    
    func rejectLinkRequest(to memberID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError> {
        return try await fetchDataNoContent(
            using: { try await service.rejectLinkRequest(from: memberID) }
        )
    }
    
    func removeLink(with memberID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError> {
        return try await fetchDataNoContent(
            using: { try await service.sendUnlinkRequest(to: memberID) }
        )
    }
    
    func checkNewLinkRequest() async throws -> NetworkResult<BaseResponse<CheckLinkRequest>, NetworkError> {
        return try await fetchData(
            using: { try await service.checkNewLinkRequest() },
            decodingTo: BaseResponseDTO<CheckLinkRequestDTO>.self,
            map: { mapper.mapCheckLinkRequestResponse(from: $0) }
        )
    }
}
