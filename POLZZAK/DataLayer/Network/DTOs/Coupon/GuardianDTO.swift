//
//  GuardianDTO.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/09.
//

import Foundation

struct GuardianDTO: Decodable {
    let nickname: String
    let profileURL: String
    
    enum CodingKeys: String, CodingKey {
        case nickname
        case profileURL = "profileUrl"
    }
}
