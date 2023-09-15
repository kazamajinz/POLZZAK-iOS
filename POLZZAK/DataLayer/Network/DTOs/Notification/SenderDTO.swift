//
//  SenderDTO.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/13.
//

import Foundation

struct SenderDTO: Decodable {
    let id: Int
    let nickname: String
    let profileURL: String

    enum CodingKeys: String, CodingKey {
        case id, nickname
        case profileURL = "profileUrl"
    }
}

