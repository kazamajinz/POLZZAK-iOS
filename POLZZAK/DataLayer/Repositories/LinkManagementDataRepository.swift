//
//  LinkManagementDataRepository.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/30.
//

import Foundation

class LinkManagementDataRepository: LinkManagementRepository {
    private let linkManagementService: LinkManagementService
    private let linkManagementMapper = LinkManagementMapper()
    
    init(linkManagementService: LinkManagementService = LinkManagementService()) {
        self.linkManagementService = linkManagementService
    }
    
    func getUserByNickname(_ nickname: String) async throws -> NetworkResult<BaseResponse<FamilyMember>, NetworkError> {
        let (data, response) = try await linkManagementService.fetchUserByNickname(nickname)
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
        let (data, response) = try await linkManagementService.fetchAllLinkedUsers()
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
        let (data, response) = try await linkManagementService.fetchAllReceivedUsers()
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
        let (data, response) = try await linkManagementService.fetchAllRequestedUsers()
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
        let (data, response) = try await linkManagementService.sendLinkRequest(to: memberID)
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
        let (_, response) = try await linkManagementService.cancelLinkRequest(to: memberID)
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
        let (_, response) = try await linkManagementService.approveLinkRequest(from: memberID)
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
        let (_, response) = try await linkManagementService.rejectLinkRequest(from: memberID)
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
        let (_, response) = try await linkManagementService.sendUnlinkRequest(to: memberID)
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
        let (data, response) = try await linkManagementService.checkNewLinkRequest()
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
