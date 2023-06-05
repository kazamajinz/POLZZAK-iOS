//
//  LoginResponseDTO.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/05.
//

import Foundation

struct SocialRegisterInfo: Decodable {
    let username: String
    let socialType: String
}

enum LoginResponsableValue: Decodable {
    case socialRegisterInfo(SocialRegisterInfo)
    case noData
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let data = try? container.decode(SocialRegisterInfo.self) {
            self = .socialRegisterInfo(data)
            return
        }
        self = .noData
    }
}

typealias LoginResponseDTO = BaseResponseDTO<LoginResponsableValue>
