//
//  UseCaseProtocol.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/17.
//

import Foundation

protocol UseCaseProtocol {
    associatedtype RepositoryType
    var repository: RepositoryType { get }
}

extension UseCaseProtocol {
    func processResult<T: ResponseDataProtocol>(_ result: NetworkResult<T, NetworkError>) throws -> T.DataType? {
        switch result {
        case .success(let response):
            return response?.data
        case .failure(let error):
            throw error
        }
    }
}
