//
//  NetworkService.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/29.
//

import Foundation
import OSLog

protocol NetworkServiceProvider {
    /// 특정 responsable이 존재하는 request
    func request<R: Decodable, E: RequestResponsable>(with endpoint: E) async throws -> R where E.Response == R
    func request<R: Decodable, E: RequestResponsable>(with endpoint: E) async throws -> (R, URLResponse) where E.Response == R
}

final class NetworkService: NetworkServiceProvider {
    private let session: URLSession
    private let requestAdapter: RequestAdapter?
    private let requestRetrier: RequestRetrier?
    
    init(
        session: URLSession = .shared,
        requestAdapter: RequestAdapter? = nil,
        requestRetrier: RequestRetrier? = nil
    ) {
        self.session = session
        self.requestAdapter = requestAdapter
        self.requestRetrier = requestRetrier
    }
    
    func request<R: Decodable, E: RequestResponsable>(with endpoint: E) async throws -> (R, URLResponse) where E.Response == R {
        var request = try endpoint.getURLRequest()
        await requestAdapter?.adapt(for: &request)
        
        os_log("request", log: .network)
        let (data, response) = try await session.data(for: request)
        
        guard let requestRetrier else {
            return (try decode(data: data), response)
        }
        
        let (dataRetried, responseRetried) = try await requestRetrier.retry(request, for: session, for: response, adaptWhenRetry: {
            await self.requestAdapter?.adapt(for: &request)
        })
        
        return (try decode(data: dataRetried), responseRetried)
    }
    
    func request<R: Decodable, E: RequestResponsable>(with endpoint: E) async throws -> R where E.Response == R {
        return try await request(with: endpoint).0
    }

    // MARK: - Private
    
    private func decode<T: Decodable>(data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
}
