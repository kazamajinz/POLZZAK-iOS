//
//  NotificationMapper.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/13.
//

import Foundation

struct NotificationMapper: MappableResponse {
    func mapNotificationResponse(from response: BaseResponseDTO<NotificationResponseDTO>) -> BaseResponse<NotificationResponse> {
        return mapBaseResponse(from: response, transform: mapNotificationResponse)
    }
    
    private func mapNotificationResponse(_ dto: NotificationResponseDTO) -> NotificationResponse {
        return NotificationResponse(
            startID: dto.startID,
            notificationList: dto.notificationListDTO.map{ mapNotification($0) }
        )
    }
    
    private func mapNotification(_ dto: NotificationDTO) -> Notification {
        return Notification(
            id: dto.id,
            type: mapNotificationType(dto.type),
            status: mapNotificationStatus(dto.status),
            title: dto.title,
            message: dto.message,
            sender: mapSender(dto.sender),
            link: mapNotificationLink(dto.link),
            requestFamilyID: dto.requestFamilyID,
            createdDate: dto.createdDate
        )
    }
    
    private func mapSender(_ dto: SenderDTO) -> Sender {
        return Sender(
            id: dto.id,
            nickname: dto.nickname,
            profileURL: dto.profileURL
        )
    }
    
    private func mapNotificationType(_ typeString: String) -> NotificationType? {
        return NotificationType(rawValue: typeString)
    }
    
    private func mapNotificationStatus(_ statusString: String) -> NotificationStatus? {
        return NotificationStatus(rawValue: statusString)
    }
    
    private func mapNotificationLink(_ typeString: String?) -> NotificationLink? {
        guard let typeString = typeString else {
            return nil
        }
        
        if false == typeString.contains("/") {
            switch typeString {
            case "home":
                return .home
            case "my-page":
                return .myPage
            default:
                return nil
            }
        } else {
            let convertType = typeString.components(separatedBy: "/")
            let type = convertType[0]
            let id = Int(convertType[1]) ?? 0
            switch type {
            case "stamp-board":
                return .stampBoard(stampBoardID: id)
            case "coupon":
                return .coupon(couponID: id)
            default:
                return nil
            }
        }
    }
}
