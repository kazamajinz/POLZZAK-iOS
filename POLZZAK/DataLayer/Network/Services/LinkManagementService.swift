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
    
    func fetchUserByNickname(_ nickname: String) async throws -> (Data, URLResponse) {
        return try await networkService.request(with: LinkManagementTargets.searchUserByNickname(nickname))
    }
    
    func fetchAllLinkedUsers() async throws -> (Data, URLResponse) {
        return try await networkService.request(with: LinkManagementTargets.fetchAllLinkedUsers)
    }
    
    func fetchAllReceivedUsers() async throws -> (Data, URLResponse) {
        return try await networkService.request(with: LinkManagementTargets.fetchAllReceivedLinkRequests)
    }
    
    func fetchAllRequestedUsers() async throws -> (Data, URLResponse) {
        return try await networkService.request(with: LinkManagementTargets.fetchAllSentLinkRequests)
    }
    
    func sendLinkRequest(to memberID: Int) async throws -> (Data, URLResponse) {
        return try await networkService.request(with: LinkManagementTargets.sendLinkRequest(memberID: memberID))
    }
    
    func cancelLinkRequest(to memberID: Int) async throws -> (Data, URLResponse) {
        return try await networkService.request(with: LinkManagementTargets.cancelSentLinkRequest(memberID: memberID))
    }
    
    func approveLinkRequest(from memberID: Int) async throws -> (Data, URLResponse) {
        return try await networkService.request(with: LinkManagementTargets.approveReceivedLinkRequest(memberID: memberID))
    }
    
    func rejectLinkRequest(from memberID: Int) async throws -> (Data, URLResponse) {
        return try await networkService.request(with: LinkManagementTargets.rejectReceivedLinkRequest(memberID: memberID))
    }
    
    func sendUnlinkRequest(to memberID: Int) async throws -> (Data, URLResponse) {
        return try await networkService.request(with: LinkManagementTargets.requestUnLink(memberID: memberID))
    }
    
    func checkNewLinkRequest() async throws -> (Data, URLResponse) {
        return try await networkService.request(with: LinkManagementTargets.checkNewLinkRequest)
    }
}
