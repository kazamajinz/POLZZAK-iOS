//
//  LinkManagementDataRepository.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/30.
//

import Foundation

class LinkManagementDataRepository: LinkManagementRepository, LinkRequestRepository {
    private let linkManagementMapper = LinkManagementMapper()
    typealias ServiceType = LinkManagementService
    var service: ServiceType
    
    init(linkManagementService: LinkManagementService = LinkManagementService()) {
        self.service = linkManagementService
    }
    
    func getUserByNickname(_ nickname: String) async throws -> NetworkResult<BaseResponse<FamilyMember>, NetworkError> {
        let (data, response) = try await service.fetchUserByNickname(nickname)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        let statusCode = httpResponse.statusCode
        switch statusCode {
        case 200..<300:
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(BaseResponseDTO<FamilyMemberDTO>.self, from: data)
            let mapData = linkManagementMapper.mapFamilyMemberResponse(from: decodedData)
            return .success(mapData)
        default:
            throw NetworkError.serverError(statusCode)
        }
    }
    
    func getLinkedUsers() async throws -> NetworkResult<BaseResponse<[FamilyMember]>, NetworkError> {
        let (data, response) = try await service.fetchAllLinkedUsers()
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        let statusCode = httpResponse.statusCode
        switch statusCode {
        case 200..<300:
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(BaseResponseDTO<FamilyMemberListDTO>.self, from: data)
            let mapData = linkManagementMapper.mapFamilyMemberListResponse(from: decodedData)
            return .success(mapData)
        default:
            throw NetworkError.serverError(statusCode)
        }
    }
    
    func getReceivedLinkRequests() async throws -> NetworkResult<BaseResponse<[FamilyMember]>, NetworkError> {
        let (data, response) = try await service.fetchAllReceivedUsers()
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        let statusCode = httpResponse.statusCode
        switch statusCode {
        case 200..<300:
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(BaseResponseDTO<FamilyMemberListDTO>.self, from: data)
            let mapData = linkManagementMapper.mapFamilyMemberListResponse(from: decodedData)
            return .success(mapData)
        default:
            throw NetworkError.serverError(statusCode)
        }
    }
    
    func getSentLinkRequests() async throws -> NetworkResult<BaseResponse<[FamilyMember]>, NetworkError> {
        let (data, response) = try await service.fetchAllRequestedUsers()
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        let statusCode = httpResponse.statusCode
        switch statusCode {
        case 200..<300:
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(BaseResponseDTO<FamilyMemberListDTO>.self, from: data)
            let mapData = linkManagementMapper.mapFamilyMemberListResponse(from: decodedData)
            return .success(mapData)
        default:
            throw NetworkError.serverError(statusCode)
        }
    }
    
    func createLinkRequest(to memberID: Int) async throws -> NetworkResult<BaseResponse<EmptyDataResponse>, NetworkError> {
        let (data, response) = try await service.sendLinkRequest(to: memberID)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        let statusCode = httpResponse.statusCode
        switch statusCode {
        case 201:
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(BaseResponseDTO<EmptyDataResponseDTO>.self, from: data)
            let mapData = linkManagementMapper.mapEmptyDataResponse(from: decodedData)
            return .success(mapData)
        default:
            throw NetworkError.serverError(statusCode)
        }
    }
    
    func deleteSentLinkRequest(to memberID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError> {
        let (_, response) = try await service.cancelLinkRequest(to: memberID)
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
    
    func removeLink(with memberID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError> {
        let (_, response) = try await service.sendUnlinkRequest(to: memberID)
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
    
    func checkNewLinkRequest() async throws -> NetworkResult<BaseResponse<CheckLinkRequest>, NetworkError> {
        let (data, response) = try await service.checkNewLinkRequest()
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        let statusCode = httpResponse.statusCode
        switch statusCode {
        case 200..<300:
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(BaseResponseDTO<CheckLinkRequestDTO>.self, from: data)
            let mapData = linkManagementMapper.mapCheckLinkRequestResponse(from: decodedData)
            return .success(mapData)
        default:
            throw NetworkError.serverError(statusCode)
        }
    }
}
