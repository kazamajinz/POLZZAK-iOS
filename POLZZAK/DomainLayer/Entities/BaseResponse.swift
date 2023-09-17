//
//  BaseResponse.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/08.
//

import Foundation

struct BaseResponse<T> {
    let code: Int
    let messages: [String]?
    let data: T?
}

struct EmptyDataResponse {
    let code: Int
    let messages: [String]?
}
