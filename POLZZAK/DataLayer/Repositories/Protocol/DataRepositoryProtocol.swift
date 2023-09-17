//
//  DataRepositoryProtocol.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/16.
//

import Foundation

protocol DataRepositoryProtocol {
    associatedtype MapperType: MappableResponse
    var mapper: MapperType { get }
}

extension DataRepositoryProtocol {
    func fetchData<T: Decodable, U>(
        using serviceCall: () async throws -> (Data, URLResponse),
        decodingTo type: T.Type,
        map transform: (T) -> U,
        handleStatusCodes: [Int] = Array(200..<300)
    ) async throws -> NetworkResult<U, NetworkError> {
        let (data, response) = try await serviceCall()

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        let statusCode = httpResponse.statusCode

        if handleStatusCodes.contains(statusCode) {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(T.self, from: data)
            let mappedData = transform(decodedData)
            return .success(mappedData)
        } else {
            throw NetworkError.invalidStatusCode(statusCode)
        }
    }
    
    func fetchDataNoContent(
        using serviceCall: () async throws -> (Data, URLResponse),
        handleStatusCodes: [Int] = [204]
    ) async throws -> NetworkResult<BaseResponse<Void>, NetworkError> {
        
        let (_, response) = try await serviceCall()
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        let statusCode = httpResponse.statusCode
        if handleStatusCodes.contains(statusCode) {
            return .success(nil)
        } else {
            throw NetworkError.invalidStatusCode(statusCode)
        }
    }
}

