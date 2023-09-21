//
//  LinkManagementService.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/30.
//

import Foundation

protocol LinkManagementService {
    func fetchUserByNickname(_ nickname: String) async throws -> (Data, URLResponse)
    func fetchAllLinkedUsers() async throws -> (Data, URLResponse)
    func fetchAllReceivedUsers() async throws -> (Data, URLResponse)
    func fetchAllRequestUsers() async throws -> (Data, URLResponse)
    func sendLinkRequest(to memberID: Int) async throws -> (Data, URLResponse)
    func cancelLinkRequest(to memberID: Int) async throws -> (Data, URLResponse)
    func approveLinkRequest(from memberID: Int) async throws -> (Data, URLResponse)
    func rejectLinkRequest(from memberID: Int) async throws -> (Data, URLResponse)
    func sendUnlinkRequest(to memberID: Int) async throws -> (Data, URLResponse)
    func checkNewLinkRequest() async throws -> (Data, URLResponse)
}

class DefaultLinkManagementService: LinkManagementService, LinkRequestService {
    var networkService: NetworkServiceProvider
    
    init(networkService: NetworkServiceProvider = NetworkService(requestInterceptor: TokenInterceptor())) {
        self.networkService = networkService
    }
    
    func fetchUserByNickname(_ nickname: String) async throws -> (Data, URLResponse) {
        return try await handleResponse(LinkManagementTargets.searchUserByNickname(nickname))
    }
    
    func fetchAllLinkedUsers() async throws -> (Data, URLResponse) {
        return try await handleResponse(LinkManagementTargets.fetchAllLinkedUsers)
    }
    
    func fetchAllReceivedUsers() async throws -> (Data, URLResponse) {
        return try await handleResponse(LinkManagementTargets.fetchAllReceivedLinkRequests)
    }
    
    func fetchAllRequestUsers() async throws -> (Data, URLResponse) {
        return try await handleResponse(LinkManagementTargets.fetchAllSentLinkRequests)
    }
    
    func sendLinkRequest(to memberID: Int) async throws -> (Data, URLResponse) {
        return try await handleResponse(LinkManagementTargets.sendLinkRequest(memberID: memberID))
    }
    
    func cancelLinkRequest(to memberID: Int) async throws -> (Data, URLResponse) {
        return try await handleResponse(LinkManagementTargets.cancelSentLinkRequest(memberID: memberID))
    }
    
    func approveLinkRequest(from memberID: Int) async throws -> (Data, URLResponse) {
        return try await handleResponse(LinkManagementTargets.approveReceivedLinkRequest(memberID: memberID))
    }
    
    func rejectLinkRequest(from memberID: Int) async throws -> (Data, URLResponse) {
        return try await handleResponse(LinkManagementTargets.rejectReceivedLinkRequest(memberID: memberID))
    }
    
    func sendUnlinkRequest(to memberID: Int) async throws -> (Data, URLResponse) {
        return try await handleResponse(LinkManagementTargets.requestUnLink(memberID: memberID))
    }
    
    func checkNewLinkRequest() async throws -> (Data, URLResponse) {
        return try await handleResponse(LinkManagementTargets.checkNewLinkRequest)
    }
}
