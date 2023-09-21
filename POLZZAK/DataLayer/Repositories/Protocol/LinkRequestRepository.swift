//
//  LinkRequestRepository.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/14.
//

import Foundation

protocol LinkRequestRepository: DataRepositoryProtocol {
    func approveLinkRequest(to memberID: Int) async throws
    func rejectLinkRequest(to memberID: Int) async throws
}

/*
extension LinkRequestRepository {
    func approveLinkRequest(to memberID: Int) async throws {
        let (_, reponse) = try await linkService.approveLinkRequest(from: memberID)
        try fetchDataNoContent(response: reponse)
    }

    func rejectLinkRequest(to memberID: Int) async throws {
        let (_, reponse) = try await linkService.rejectLinkRequest(from: memberID)
        try fetchDataNoContent(response: reponse)
    }
}
*/
