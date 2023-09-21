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

extension BaseResponse: ResponseDataProtocol {
    typealias DataType = T
}

struct EmptyDataResponse: Equatable {
    let code: Int
    let messages: [String]?
}

extension EmptyDataResponse: ResponseDataProtocol {
    typealias DataType = Void
    var data: Void? { return nil }
}
