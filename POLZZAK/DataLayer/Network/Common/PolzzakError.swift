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

/*
extension PolzzakError {
    static func validate(code: Int) throws {
        if 200..<300 ~= code {
            return
        } else {
            throw NetworkError.invalidHTTPStatusCode(code)
        }
    }
}
*/

