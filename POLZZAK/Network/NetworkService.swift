//
//  NetworkService.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/29.
//

import Foundation

protocol NetworkServiceProvider {
    /// 특정 responsable이 존재하는 request
    func request<R: Decodable, E: RequestResponsable>(with endpoint: E) async throws -> R where E.Response == R

    /// URL에서 Data를 얻는 request
    func request(from url: URL) async throws -> Data
}

final class NetworkService: NetworkServiceProvider {
    let session: URLSessionProvider
    
    init(session: URLSessionProvider = URLSession.shared) {
        self.session = session
    }
    
    func request<R: Decodable, E: RequestResponsable>(with endpoint: E) async throws -> R where E.Response == R {
        let urlRequest = try endpoint.getUrlRequest()
        let (data, response) = try await session.data(for: urlRequest)
        try checkError(response: response)
        return try decode(data: data)
    }
    
    func request(from url: URL) async throws -> Data {
        let (data, response) = try await session.data(from: url)
        try checkError(response: response)
        return data
    }

    // MARK: - Private
    
    private func checkError(response: URLResponse) throws {
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.unknownError
        }

        guard (200...299).contains(response.statusCode) else {
            throw NetworkError.invalidHTTPStatusCode(response.statusCode)
        }
    }
    
    private func decode<T: Decodable>(data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
}
