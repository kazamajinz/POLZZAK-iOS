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

enum ResponseStatus {
    case success
    case failure
}

struct EmptyDataResponseDTO: Decodable {
    let code: Int
    let messages: [String]?
}

struct EmptyDataResponse {
    let code: Int
    let messages: [String]?
}

struct EmptyResponseDTO: Decodable {}

enum NetworkResult<Success, Failure> {
    case success(Success?)
    case failure(Failure)
}
