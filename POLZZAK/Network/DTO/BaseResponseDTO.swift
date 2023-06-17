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

// TODO: BaseResponse 사용하는 로직 만들기
struct BaseResponse: Decodable {
    let code: Int
    let messages: [String]?
    let data: [String: String]?
}
