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

class DefaultNotificationUseCase: NotificationUseCase {
    let repository: NotificationRepository
    
    init(repository: NotificationRepository) {
        self.repository = repository
    }
    
    func fetchNotificationList(with startID: Int?) -> Task<NotificationResponse?, Error> {
        return Task {
            do {
                let result = try await repository.fetchNotificationList(with: startID)
                switch result {
                case .success(let response):
                    if let response = response, response.code == 413 {
                        return nil
                    } else if let data = response?.data {
                        return data
                    } else {
                        throw NetworkError.emptyReponse
                    }
                case .failure(let error):
                    throw error
                }
            } catch {
                throw error
            }
        }
    }
    
    func removeNotification(with notificationID: Int) -> Task<Void, Error> {
        return Task {
            do {
                let result = try await self.repository.removeNotification(with: notificationID)
                switch result {
                case .success:
                    print("성공했습니다.")
                    break
                case .failure(let error):
                    throw error
                }
            } catch {
                throw error
            }
        }
    }
    
    func approveReceivedLinkRequest(from memberID: Int) -> Task<Void, Error> {
        return Task {
            do {
                let result = try await self.repository.approveLinkRequest(to: memberID)
                switch result {
                case .success:
                    break
                case .failure(let error):
                    throw error
                }
            } catch {
                throw error
            }
        }
    }
    
    func rejectReceivedLinkRequest(from memberID: Int) -> Task<Void, Error> {
        return Task {
            do {
                let result = try await self.repository.rejectLinkRequest(to: memberID)
                switch result {
                case .success:
                    break
                case .failure(let error):
                    throw error
                }
            } catch {
                throw error
            }
        }
    }
}
