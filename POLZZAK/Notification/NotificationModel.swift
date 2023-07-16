//
//  NotificationModel.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/07/12.
//

import Foundation

struct NotificationModel {
    let type: NotificationType
    let date: String
    let description: String
    let link: String
    let sender: String
    let profileURL: String
    let stampBoardName: String
    let rewardName: String
    let level: String
    let isNew: Bool
    
    init(from dto: NotificationDTO) throws {
        guard let notificationType = NotificationType(rawValue: dto.type) else {
            throw NetworkError.unknownError
        }
        
        self.type = notificationType
        self.date = NotificationModel.convertDate(from: dto.date)
        self.description = dto.description
        self.link = dto.link
        self.sender = dto.sender
        self.profileURL = dto.profileURL
        self.stampBoardName = dto.stampBoardName
        self.rewardName = dto.rewardName
        self.level = dto.level
        self.isNew = dto.isNew
    }

    
    private static func convertDate(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: dateString) {
            let now = Date()
            let interval = now.timeIntervalSince(date)
            
            switch interval {
            case 0..<30:
                return "방금 전"
            case 30..<60:
                return "1분 전"
            case 60..<3600:
                return "\(Int(interval / 60))분 전"
            case 3600..<86400:
                return "\(Int(interval / 3600))시간 전"
            default:
                return "\(Int(interval / 86400))일 전"
            }
        } else {
            return "날짜 형식이 잘못됨"
        }
    }
}
