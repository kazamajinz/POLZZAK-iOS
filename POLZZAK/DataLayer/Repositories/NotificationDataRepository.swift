//
//  NotificationDataRepository.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/13.
//

import Foundation

class NotificationDataRepository: NotificationRepository, LinkRequestRepository {
    private let notificationMapper = NotificationMapper()
    typealias ServiceType = NotificationService
    var service: ServiceType
    
    init(notificationService: NotificationService = NotificationService()) {
        self.service = notificationService
    }
    
    func fetchNotificationList(with startID: Int?) async throws -> NetworkResult<BaseResponse<NotificationResponse>, NetworkError> {
        let (data, response) = try await service.fetchNotificationList(with: startID)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        let statusCode = httpResponse.statusCode
        switch statusCode {
        case 200..<300:
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(BaseResponseDTO<NotificationResponseDTO>.self, from: data)
            let mapData = notificationMapper.mapNotificationResponse(from: decodedData)
            return .success(mapData)
        case 400:
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(BaseResponseDTO<EmptyDataResponseDTO>.self, from: data)
            let mapData = notificationMapper.mapEmptyDataResponse(from: decodedData)
            if mapData.code == 413 {
                return .success(BaseResponse<NotificationResponse>(code: mapData.code, messages: mapData.messages, data: nil))
            } else {
                throw NetworkError.serverError(mapData.code)
            }
        default:
            throw NetworkError.serverError(statusCode)
        }
    }
    
    func removeNotification(with notificationID: Int) async throws -> NetworkResult<BaseResponse<EmptyDataResponse>, NetworkError> {
        let (_, response) = try await service.removeNotification(with: notificationID)
        
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
