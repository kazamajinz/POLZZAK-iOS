//
//  PolzzakError.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/31.
//

import Foundation

enum PolzzakError: Error {
    case repositoryError(code: Int, messages: [String]?)
    case invalidStatusCode(_ statusCode: Int)
    case serviceError(_ statusCode: Int)
    case serverError
    case unknownError
}

extension PolzzakError: CustomStringConvertible {
    var description: String {
        switch self {
        case .serviceError(let statusCode):
            return """
                Error Type: serviceError
                Error Code: \(statusCode)
                Messages: \(HTTPURLResponse.localizedString(forStatusCode: statusCode))
                """
            
        case .repositoryError(let code, let messages):
            return """
                Error Type: RepositoryError
                Error Code: \(code)
                Messages: \(String(describing: messages?.joined(separator: ", ")))
                """
            
        case .invalidStatusCode(let statusCode):
            return """
                Error Type: InvalidStatusCode
                Error Code: \(statusCode)
                Messages: \(HTTPURLResponse.localizedString(forStatusCode: statusCode))
                """
        case .serverError:
            return "ServerError"
            
        case .unknownError:
            return "UnknownError"
        }
    }
}
