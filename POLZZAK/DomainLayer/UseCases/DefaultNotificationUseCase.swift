//
//  DefaultNotificationUseCase.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/13.
//

protocol NotificationUseCase {
    func fetchNotificationList(with startID: Int?) -> Task<NotificationResponse?, Error>
    func removeNotification(with notificationID: Int) -> Task<Void, Error>
    func approveReceivedLinkRequest(from memberID: Int) -> Task<Void, Error>
    func rejectReceivedLinkRequest(from memberID: Int) -> Task<Void, Error>
}

import Foundation

class DefaultNotificationUseCase: UseCaseProtocol, NotificationUseCase {
    let repository: NotificationRepository
    
    init(repository: NotificationRepository) {
        self.repository = repository
    }
    
    func fetchNotificationList(with startID: Int?) -> Task<NotificationResponse?, Error> {
        return Task {
            let result = try await repository.fetchNotificationList(with: startID)
            return try processResult(result)
        }
    }
    
    func removeNotification(with notificationID: Int) -> Task<Void, Error> {
        return Task {
            let result = try await repository.removeNotification(with: notificationID)
            _ = try processResult(result)
        }
    }
    
    func approveReceivedLinkRequest(from memberID: Int) -> Task<Void, Error> {
        return Task {
            let result = try await repository.approveLinkRequest(to: memberID)
            _ = try processResult(result)
        }
    }
    
    func rejectReceivedLinkRequest(from memberID: Int) -> Task<Void, Error> {
        return Task {
            let result = try await repository.rejectLinkRequest(to: memberID)
            _ = try processResult(result)
        }
    }
}
