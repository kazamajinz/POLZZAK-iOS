//
//  LinkRequestRepository.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/14.
//

import Foundation

protocol LinkRequestRepository: DataRepositoryProtocol {
    associatedtype ServiceType: LinkRequestService
    var service: ServiceType { get }
    
    func approveLinkRequest(to memberID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
    func rejectLinkRequest(to memberID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
}

extension LinkRequestRepository {
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
}
