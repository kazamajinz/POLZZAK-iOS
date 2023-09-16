//
//  NotificationRepository.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/13.
//

import Foundation

protocol NotificationRepository {
    func fetchNotificationList(with startID: Int?) async throws -> NetworkResult<BaseResponse<NotificationResponse>, NetworkError>
    func removeNotification(with notificationID: Int) async throws -> NetworkResult<BaseResponse<EmptyDataResponse>, NetworkError>
    func approveLinkRequest(to memberID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
    func rejectLinkRequest(to memberID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
}
