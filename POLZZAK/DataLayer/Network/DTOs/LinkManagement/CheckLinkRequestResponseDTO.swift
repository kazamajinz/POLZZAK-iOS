//
//  CheckLinkRequestResponseDTO.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/03.
//

import Foundation

struct CheckLinkRequestDTO: Decodable {
    let isFamilyReceived: Bool
    let isFamilySent: Bool
}
