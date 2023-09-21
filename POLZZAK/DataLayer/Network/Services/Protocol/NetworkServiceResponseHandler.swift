//
//  NetworkServiceResponseHandler.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/20.
//

import Foundation

protocol NetworkServiceResponseHandler {
    var networkService: NetworkServiceProvider { get }
    func handleResponse(_ target: TargetType) async throws -> (Data, URLResponse)
}

extension NetworkServiceResponseHandler {
    func handleResponse(_ target: TargetType) async throws -> (Data, URLResponse) {
        let (data, response) = try await networkService.request(with: target)
        
        if let httpURLResponse = response as? HTTPURLResponse {
            switch httpURLResponse.statusCode {
            case 200..<300:
                return (data, response)
            default:
                throw PolzzakError.serviceError(httpURLResponse.statusCode)
            }
        } else {
            throw PolzzakError.serverError
        }
    }
}
