//
//  DataRepositoryProtocol.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/16.
//

import Foundation

protocol DataRepositoryProtocol {
    associatedtype MapperType: Mappable
    var mapper: MapperType { get }
}

extension DataRepositoryProtocol {
    func fetchData<T: Decodable, U>(
        using serviceCall: () async throws -> (Data, URLResponse),
        decodingTo type: T.Type,
        map transform: (T) -> U
    ) async throws -> U {
        let (data, response) = try await serviceCall()
        
        try validateHttpResponse(response, with: data)
        
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(T.self, from: data)
        
        return transform(decodedData)
    }
    
    private func validateHttpResponse(
        _ response: URLResponse,
        with data: Data,
        validStatusCodes: [Int] = Array(200..<300)
    ) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard validStatusCodes.contains(httpResponse.statusCode) else {
            throw try parseErrorResponse(data: data)
        }
    }
    
    private func parseErrorResponse(data: Data) throws -> PolzzakError {
        let decoder = JSONDecoder()
        let errorResponse = try decoder.decode(BaseResponseDTO<EmptyDataResponseDTO>.self, from: data)
        return PolzzakError.repositoryError(code: errorResponse.code, messages: errorResponse.messages)
    }
    
    func fetchDataNoContent(response: URLResponse) throws {
        try validateHttpResponse(response, with: Data(), validStatusCodes: [204])
    }
}
