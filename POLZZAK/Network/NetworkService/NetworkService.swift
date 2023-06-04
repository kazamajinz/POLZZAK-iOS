//
//  NetworkService.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/29.
//

import Foundation

protocol NetworkServiceProvider {
    /// 특정 responsable이 존재하는 request
    func request<R: Decodable, E: RequestResponsable>(with endpoint: E) async throws -> (R, URLResponse) where E.Response == R

    /// URL에서 Data를 얻는 request
    func request(from url: URL) async throws -> Data
}

final class NetworkService: NetworkServiceProvider {
    private let session: URLSession
    private let requestAdapter: RequestAdapter?
    private let requestRetrier: RequestRetrier?
    
    init(
        session: URLSession = .shared,
        requestAdapter: RequestAdapter = AuthAdapter(),
        requestRetrier: RequestRetrier = AuthRetrier()
    ) {
        self.session = session
        self.requestAdapter = requestAdapter
        self.requestRetrier = requestRetrier
    }
    
    func request<R: Decodable, E: RequestResponsable>(with endpoint: E) async throws -> (R, URLResponse) where E.Response == R {
        var request = try endpoint.getURLRequest()
        requestAdapter?.adapt(for: &request)
        let (data, response) = try await session.data(for: request)
        
        guard let requestRetrier else {
            return (try decode(data: data), response)
        }
        
        let (dataRetried, responseRetried) = try await requestRetrier.retry(request, for: session, for: response)
        return (try decode(data: dataRetried), responseRetried)
    }
    
    func request(from url: URL) async throws -> Data {
        let (data, _) = try await session.data(from: url)
        return data
    }

    // MARK: - Private
    
    private func decode<T: Decodable>(data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
}
