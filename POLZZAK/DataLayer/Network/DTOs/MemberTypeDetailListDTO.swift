//
//  MemberTypeDetailListDTO.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/28.
//

import Foundation

struct MemberTypeDetailListDTO: Codable {
    let memberTypeDetailList: [MemberTypeDetail]
}

extension MemberTypeDetailListDTO {
    struct MemberTypeDetail: Codable {
        let memberTypeDetailId: Int
        let detail: String
    }
}
