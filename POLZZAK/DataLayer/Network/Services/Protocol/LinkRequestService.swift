//
//  LinkRequestService.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/14.
//

import Foundation

protocol LinkRequestService {
    var networkService: NetworkServiceProvider { get }
    func approveLinkRequest(from memberID: Int) async throws -> (Data, URLResponse)
    func rejectLinkRequest(from memberID: Int) async throws -> (Data, URLResponse)
}

extension LinkRequestService {
    func approveLinkRequest(from memberID: Int) async throws -> (Data, URLResponse) {
        return try await networkService.request(with: LinkManagementTargets.approveReceivedLinkRequest(memberID: memberID))
    }
    
    func rejectLinkRequest(from memberID: Int) async throws -> (Data, URLResponse) {
        return try await networkService.request(with: LinkManagementTargets.rejectReceivedLinkRequest(memberID: memberID))
    }
}
