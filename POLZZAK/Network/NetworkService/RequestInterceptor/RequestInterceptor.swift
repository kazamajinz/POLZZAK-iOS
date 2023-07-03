//
//  RequestInterceptor.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/10.
//

import Foundation

protocol RequestInterceptor: RequestAdapter, RequestRetrier {}

extension RequestInterceptor {
    var maxRetryCount: Int {
        return 1
    }
    
    func adapt(for urlRequest: URLRequest) async throws -> URLRequest {
        return urlRequest
    }
    
    func retry(response: URLResponse) async throws -> RetryResult {
        return .doNotRetry
    }
}
