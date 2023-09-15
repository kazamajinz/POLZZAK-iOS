//
//  PolzzakError.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/31.
//

import Foundation

enum PolzzakError<T>: Error {
    case serviceError
    case repositoryError
    case usecaseError
    case mappingError
    case responseError(BaseResponse<T>)
    case decodingError
}
