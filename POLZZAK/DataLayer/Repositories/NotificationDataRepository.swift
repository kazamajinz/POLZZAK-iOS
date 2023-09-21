//
//  NotificationDataRepository.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/13.
//

import Foundation

protocol NotificationRepository {
    func fetchNotificationList(with startID: Int?) async throws -> NotificationResponse?
    func removeNotification(with notificationID: Int) async throws
}

final class NotificationDataRepository: DataRepositoryProtocol, NotificationRepository, LinkRequestRepository {
    typealias MapperType = DefaultNotificationMapper
    let mapper: MapperType = DefaultNotificationMapper()
    
    typealias ServiceType = NotificationService
    var service: ServiceType
    
    init(notificationService: NotificationService = NotificationService()) {
        self.service = notificationService
    }
    
    func fetchNotificationList(with startID: Int?) async throws -> NotificationResponse? {
        let response: BaseResponse<NotificationResponse> = try await fetchData(
            using: { try await service.fetchNotificationList(with: startID) },
            decodingTo: BaseResponseDTO<NotificationResponseDTO>.self,
            map: mapper.mapNotificationResponse
        )
        return response.data
    }
    
    func removeNotification(with notificationID: Int) async throws {
        let (_, reponse) = try await service.removeNotification(with: notificationID)
        try fetchDataNoContent(response: reponse)
    }
    
    func approveLinkRequest(to memberID: Int) async throws {
        let (_, reponse) = try await service.approveLinkRequest(from: memberID)
        try fetchDataNoContent(response: reponse)
    }
    
    func rejectLinkRequest(to memberID: Int) async throws {
        let (_, reponse) = try await service.rejectLinkRequest(from: memberID)
        try fetchDataNoContent(response: reponse)
    }
}
