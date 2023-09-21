//
//  LinkManagementDataRepository.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/30.
//

import Foundation

protocol LinkManagementRepository {
    func getUserByNickname(_ nickname: String) async throws -> FamilyMember?
    func getLinkedUsers() async throws -> [FamilyMember]
    func getReceivedLinkRequests() async throws -> [FamilyMember]
    func getSentLinkRequests() async throws -> [FamilyMember]
    func createLinkRequest(to memberID: Int) async throws -> EmptyDataResponse?
    func deleteSentLinkRequest(to memberID: Int) async throws
    func removeLink(with memberID: Int) async throws
    func checkNewLinkRequest() async throws -> CheckLinkRequest?
}

final class LinkManagementDataRepository: DataRepositoryProtocol, LinkManagementRepository, LinkRequestRepository {
    typealias MapperType = DefaultLinkManagementMapper
    let mapper: MapperType = DefaultLinkManagementMapper()
    
    typealias ServiceType = LinkManagementService
    var service: ServiceType
    
    init(linkManagementService: LinkManagementService = DefaultLinkManagementService()) {
        self.service = linkManagementService
    }
    
    func getUserByNickname(_ nickname: String) async throws -> FamilyMember? {
        let response: BaseResponse<FamilyMember> = try await fetchData(
            using: { try await service.fetchUserByNickname(nickname) },
            decodingTo: BaseResponseDTO<FamilyMemberDTO>.self,
            map: mapper.mapFamilyMemberResponse
        )
        return response.data
    }
    
    func getLinkedUsers() async throws -> [FamilyMember] {
        let response: BaseResponse<[FamilyMember]> = try await fetchData(
            using: { try await service.fetchAllLinkedUsers() },
            decodingTo: BaseResponseDTO<FamilyMemberListDTO>.self,
            map: mapper.mapFamilyMemberListResponse
        )
        return response.data ?? []
    }
    
    func getReceivedLinkRequests() async throws -> [FamilyMember] {
        let response: BaseResponse<[FamilyMember]> = try await fetchData(
            using: { try await service.fetchAllReceivedUsers() },
            decodingTo: BaseResponseDTO<FamilyMemberListDTO>.self,
            map: mapper.mapFamilyMemberListResponse
        )
        return response.data ?? []
    }
    
    func getSentLinkRequests() async throws -> [FamilyMember] {
        let response: BaseResponse<[FamilyMember]> = try await fetchData(
            using: { try await service.fetchAllRequestUsers() },
            decodingTo: BaseResponseDTO<FamilyMemberListDTO>.self,
            map: mapper.mapFamilyMemberListResponse
        )
        return response.data ?? []
    }
    
    //TODO: - 수정할것
    func createLinkRequest(to memberID: Int) async throws -> EmptyDataResponse? {
        let response: BaseResponse<EmptyDataResponse> = try await fetchData(
            using: { try await service.sendLinkRequest(to: memberID) },
            decodingTo: BaseResponseDTO<EmptyDataResponseDTO>.self,
            map: mapper.mapEmptyDataResponse
        )
        return response.data
    }
    
    func deleteSentLinkRequest(to memberID: Int) async throws {
        let (_, reponse) = try await service.cancelLinkRequest(to: memberID)
        try fetchDataNoContent(response: reponse)
    }

    func approveLinkRequest(to memberID: Int) async throws {
        let (_, reponse) = try await service.approveLinkRequest(from: memberID)
        try fetchDataNoContent(response: reponse)
    }
    
    func rejectLinkRequest(to memberID: Int) async throws {
        let (_, reponse) = try await service.rejectLinkRequest(from: memberID)
        try fetchDataNoContent(response: reponse)
    }
    
    func removeLink(with memberID: Int) async throws {
        let (_, reponse) = try await service.sendUnlinkRequest(to: memberID)
        try fetchDataNoContent(response: reponse)
    }
    
    func checkNewLinkRequest() async throws -> CheckLinkRequest? {
        let response: BaseResponse<CheckLinkRequest> = try await fetchData(
            using: { try await service.checkNewLinkRequest() },
            decodingTo: BaseResponseDTO<CheckLinkRequestDTO>.self,
            map: mapper.mapCheckLinkRequestResponse
        )
        return response.data
    }
}
