//
//  NetworkService.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/29.
//

import Foundation
import OSLog

protocol NetworkServiceProvider {
    func request(with target: TargetType) async throws -> (Data, URLResponse)
}
 
final class NetworkService: NetworkServiceProvider {
    private let session: URLSession
    private let requestInterceptor: RequestInterceptor?
    private var retryCount = ThreadSafeDictionary<URLRequest, Int>()
    private var currentTask: URLSessionTask?
    
    init(
        session: URLSession = .shared,
        requestInterceptor: RequestInterceptor? = nil
    ) {
        self.session = session
        self.requestInterceptor = requestInterceptor
    }
    
    /// 재귀로 retry 로직이 있는 request
    func request(with target: TargetType) async throws -> (Data, URLResponse) {
        var request = try target.getURLRequest()
        
        guard let requestInterceptor else {
            os_log("request", log: .network)
            logRequest(request: request)
            let (data, response) = try await session.data(for: request)
            logResponse(data: data, response: response)
            return (data, response)
        }
        
        os_log("adapt", log: .network)
        request = try await requestInterceptor.adapt(for: request)
        os_log("request", log: .network)
        logRequest(request: request)
        let (data, response) = try await session.data(for: request)
        logResponse(data: data, response: response)
        os_log("retry", log: .network)
        let retryResult = try await requestInterceptor.retry(previousData: data, response: response)
        
        if retryResult.retryRequired {
            guard continueRetry(request) else {
                return (data, response)
            }
            
            if let delay = retryResult.delay {
                try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
            
            return try await self.request(with: target)
        } else {
            if let error = retryResult.error {
                os_log("doNotRetry with error: %@", log: .network, String(describing: error))
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
    
    private func logRequest(request: URLRequest) {
        if let url = request.url?.absoluteString {
            os_log("request url\n%@", log: .network, url)
        }
        if let httpMethod = request.httpMethod {
            os_log("request httpMethod\n%@", log: .network, httpMethod)
        }
        os_log("request headers\n%@", log: .network, request.headers.description)
        if let httpBody = request.httpBody {
            os_log("request body\n%@", log: .network, String(decoding: httpBody, as: UTF8.self))
        }
    }
    
    private func logResponse(data: Data, response: URLResponse) {
        if let statusCode = (response as? HTTPURLResponse)?.statusCode {
            os_log("response statusCode\n%@", log: .network, String(statusCode))
        }
        //TODO: - 회의예정
        /*
        if let prettyJSON = data.prettyJSON {
            os_log("response JSON\n%@", log: .network, prettyJSON)
        }
         */
    }
}
