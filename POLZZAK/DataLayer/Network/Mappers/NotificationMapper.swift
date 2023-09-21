//
//  NotificationMapper.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/13.
//

import Foundation

protocol NotificationMapper {
    func mapNotificationResponse(from response: BaseResponseDTO<NotificationResponseDTO>) -> BaseResponse<NotificationResponse>
}

struct DefaultNotificationMapper: Mappable {
    func mapNotificationResponse(from response: BaseResponseDTO<NotificationResponseDTO>) -> BaseResponse<NotificationResponse> {
        return mapBaseResponse(from: response, transform: mapNotificationResponse)
    }
    
    private func mapNotificationResponse(_ dto: NotificationResponseDTO) -> NotificationResponse {
        return NotificationResponse(
            startID: dto.startID,
            notificationList: dto.notificationListDTO.map{ mapNotification($0) }
        )
    }
    
    private func mapNotification(_ dto: NotificationDTO) -> NotificationData {
        return NotificationData(
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
    
    func mapNotificationLink(_ typeString: String?) -> NotificationLink? {
        guard let typeString = typeString else {
            return nil
        }
        let components = typeString.components(separatedBy: "/")
        
        switch components.first {
        case "home":
            return .home
        case "my-page":
            return .myPage
        case "stamp-board":
            if let id = Int(components[1]) {
                return .stampBoard(stampBoardID: id)
            }
        case "coupon":
            if let id = Int(components[1]) {
                return .coupon(couponID: id)
            }
        default:
            return nil
        }
        
        return nil
    }
}
