//
//  NetworkService.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/29.
//

import Foundation
import OSLog

protocol NetworkServiceProvider {
    func request(with api: TargetType) async throws -> (Data, URLResponse)
}

extension NetworkServiceProvider {
    func requestData(with api: TargetType) async throws -> Data {
        return try await request(with: api).0
    }
    
    func request<T: Decodable>(responseType: T.Type, with api: TargetType) async throws -> (T, URLResponse) {
        let (data, response) = try await request(with: api)
        return (try JSONDecoder().decode(T.self, from: data), response)
    }
    
    func requestData<T: Decodable>(responseType: T.Type, with api: TargetType) async throws -> T {
        let (data, _) = try await request(with: api)
        return try JSONDecoder().decode(T.self, from: data)
    }
}

final class NetworkService: NetworkServiceProvider {
    private let session: URLSession
    private let requestInterceptor: RequestInterceptor?
    private var retryCount = ThreadSafeDictionary<URLRequest, Int>()
    
    init(
        session: URLSession = .shared,
        requestInterceptor: RequestInterceptor? = nil
    ) {
        self.session = session
        self.requestInterceptor = requestInterceptor
    }
    
    /// 재귀로 retry 로직이 있는 request
    func request(with api: TargetType) async throws -> (Data, URLResponse) {
        var request = try api.getURLRequest()
        
        guard let requestInterceptor else {
            os_log("request", log: .network)
            return try await session.data(for: request)
        }
        
        os_log("adapt", log: .network)
        request = try await requestInterceptor.adapt(for: request)
        os_log("request", log: .network)
        let (data, response) = try await session.data(for: request)
        os_log("retry", log: .network)
        let retryResult = try await requestInterceptor.retry(response: response)
        
        if retryResult.retryRequired {
            guard continueRetry(request) else {
                return (data, response)
            }
            
            if let delay = retryResult.delay {
                try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
            
            return try await self.request(with: api)
        } else {
            if let error = retryResult.error {
                os_log("retry error: #@", log: .network, String(describing: error))
            }
            
            return (data, response)
        }
    }
    
    private func continueRetry(_ request: URLRequest) -> Bool {
        guard let maxRetryCount = requestInterceptor?.maxRetryCount else { return false }
        
        guard maxRetryCount > 0 && (retryCount[request] == nil || retryCount[request]! < maxRetryCount) else {
            retryCount[request] = nil
            return false
        }
        
        if retryCount[request] == nil {
            retryCount[request] = 1
        }  else if retryCount[request]! < maxRetryCount {
            retryCount[request]! += 1
        }
        
        return true
    }
}
