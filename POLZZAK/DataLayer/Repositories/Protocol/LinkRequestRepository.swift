//
//  LinkRequestRepository.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/14.
//

import Foundation

protocol LinkRequestRepository {
    associatedtype ServiceType: LinkRequestService
    var service: ServiceType { get }
    
    func approveLinkRequest(to memberID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
    func rejectLinkRequest(to memberID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
}

extension LinkRequestRepository {
    func approveLinkRequest(to memberID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError> {
        let (_, response) = try await service.approveLinkRequest(from: memberID)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        let statusCode = httpResponse.statusCode
        switch statusCode {
        case 204:
            return .success(nil)
        default:
            throw NetworkError.serverError(statusCode)
        }
    }
    
    func rejectLinkRequest(to memberID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError> {
        let (_, response) = try await service.rejectLinkRequest(from: memberID)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        let statusCode = httpResponse.statusCode
        switch statusCode {
        case 204:
            return .success(nil)
        default:
            throw NetworkError.serverError(statusCode)
        }
    }
}
