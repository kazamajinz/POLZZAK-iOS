//
//  BaseResponseDTO.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/30.
//

import Foundation

struct BaseResponseDTO<T: Decodable>: Decodable {
    let code: Int
    let messages: [String]?
    let data: T?
}

struct EmptyDataResponseDTO: Decodable {
    let code: Int
    let messages: [String]?
}
