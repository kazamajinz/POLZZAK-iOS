//
//  LinkManagementService.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/30.
//

import Foundation

class LinkManagementService {
    private let networkService: NetworkServiceProvider
    
    init(networkService: NetworkServiceProvider = NetworkService(requestInterceptor: TokenInterceptor())) {
        self.networkService = networkService
    }
    
    func fetchUserByNickname(_ nickname: String) async throws -> BaseResponseDTO<FamilyMemberDTO?> {
        let target = LinkManagementTarget.searchUserByNickname(nickname: nickname)
        let response = try await networkService.requestData(responseType: BaseResponseDTO<FamilyMemberDTO?>.self, with: target)
        return response
    }
    
    func fetchAllLinkedUsers() async throws -> BaseResponseDTO<FamilyMemberResponseDTO> {
        let target = LinkManagementTarget.fetchAllLinkedUsers
        let response = try await networkService.requestData(responseType: BaseResponseDTO<FamilyMemberResponseDTO>.self, with: target)
        return response
    }
    
    func fetchAllReceivedUsers() async throws -> BaseResponseDTO<FamilyMemberResponseDTO> {
        let target = LinkManagementTarget.fetchAllReceivedLinkRequests
        let response = try await networkService.requestData(responseType: BaseResponseDTO<FamilyMemberResponseDTO>.self, with: target)
        return response
    }
    
    func fetchAllRequestedUsers() async throws -> BaseResponseDTO<FamilyMemberResponseDTO> {
        let target = LinkManagementTarget.fetchAllSentLinkRequests
        let response = try await networkService.requestData(responseType: BaseResponseDTO<FamilyMemberResponseDTO>.self, with: target)
        return response
    }
    
    func sendLinkRequest(to memberID: Int) async throws {
        let target = LinkManagementTarget.sendLinkRequest(memberID: memberID)
        try await networkService.sendRequest(with: target)
    }
    
    func cancelLinkRequest(to memberID: Int) async throws {
        let target = LinkManagementTarget.cancelSentLinkRequest(memberID: memberID)
        try await networkService.sendRequest(with: target)
    }
    
    func approveLinkRequest(from memberID: Int) async throws {
        let target = LinkManagementTarget.approveReceivedLinkRequest(memberID: memberID)
        try await networkService.sendRequest(with: target)
    }
    
    func rejectLinkRequest(from memberID: Int) async throws {
        let target = LinkManagementTarget.rejectReceivedLinkRequest(memberID: memberID)
        try await networkService.sendRequest(with: target)
    }
    
    func sendUnlinkRequest(to memberID: Int) async throws {
        let target = LinkManagementTarget.requestUnLink(memberID: memberID)
        try await networkService.sendRequest(with: target)
    }
    
    func checkNewLinkRequest() async throws -> BaseResponseDTO<CheckLinkRequestResponseDTO> {
        let target = LinkManagementTarget.checkNewLinkRequest
        let response = try await networkService.requestData(responseType: BaseResponseDTO<CheckLinkRequestResponseDTO>.self, with: target)
        return response
    }
}
