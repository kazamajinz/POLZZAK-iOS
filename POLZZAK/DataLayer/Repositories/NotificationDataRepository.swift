//
//  NotificationDataRepository.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/13.
//

import Foundation

class NotificationDataRepository: DataRepositoryProtocol, NotificationRepository, LinkRequestRepository {
    typealias MapperType = NotificationMapper
    let mapper: MapperType = NotificationMapper()
    
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
            let mapData = mapper.mapNotificationResponse(from: decodedData)
            return .success(mapData)
            //TODO: - 서버 알림쪽이 지금 이상함... 해당부분 테스트를 못하는중... 더이상 불러올 데이터가 없으면 아래처럼 뜸... 추상화 고민필요...
        case 400:
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(BaseResponseDTO<EmptyDataResponseDTO>.self, from: data)
            let mapData = mapper.mapEmptyDataResponse(from: decodedData)
            if mapData.code == 413 {
                return .success(BaseResponse<NotificationResponse>(code: mapData.code, messages: mapData.messages, data: nil))
            } else {
                throw NetworkError.invalidStatusCode(mapData.code)
            }
        default:
            throw NetworkError.invalidStatusCode(statusCode)
        }
    }
    
    func removeNotification(with notificationID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError> {
        return try await fetchDataNoContent(
            using: { try await service.removeNotification(with: notificationID) }
        )
    }
}
