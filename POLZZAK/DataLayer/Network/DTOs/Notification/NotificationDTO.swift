//
//  NotificationDTO.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/13.
//

import Foundation

struct NotificationResponseDTO: Decodable {
    let startID: Int?
    let notificationListDTO: [NotificationDTO]

    enum CodingKeys: String, CodingKey {
        case startID = "startId"
        case notificationListDTO = "notificationDtoList"
    }
}

struct NotificationDTO: Decodable {
    let id: Int
    let type: String
    let status: String
    let title: String
    let message: String
    let sender: SenderDTO
    let link: String?
    let requestFamilyID: Int?
    let createdDate: String

    enum CodingKeys: String, CodingKey {
        case id, type, status, title, message, sender, link
        case requestFamilyID = "requestFamilyId"
        case createdDate
    }
}
