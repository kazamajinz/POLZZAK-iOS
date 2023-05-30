//
//  RequestRetrier.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/30.
//

import Foundation

protocol RequestRetrier {
    func retry(for urlRequest: URLRequest, session: URLSession) async throws -> (Data, URLResponse)
    func checkErrorIfRetry(response: URLResponse) -> Bool
}

class AuthRetrier: RequestRetrier {
    private var retryCount = ThreadSafeDictionary<URLRequest, Int>()
    private let maxRetryCount: Int
    
    init(maxRetryCount: Int = 3) {
        self.maxRetryCount = maxRetryCount
    }
    
    func retry(for urlRequest: URLRequest, session: URLSession) async throws -> (Data, URLResponse) {
        print("retry: \(retryCount[urlRequest])")
        let (data, response) = try await session.data(for: urlRequest)
        guard checkErrorIfRetry(response: response) else { return (data, response) }
        
        if retryCount[urlRequest] == nil {
            retryCount[urlRequest] = 2
            return try await retry(for: urlRequest, session: session)
        } else if retryCount[urlRequest]! < maxRetryCount {
            retryCount[urlRequest]! += 1
            return try await retry(for: urlRequest, session: session)
        } else {
            retryCount[urlRequest] = nil
            return (data, response)
        }
    }
    
    func checkErrorIfRetry(response: URLResponse) -> Bool {
        guard let httpResponse = response as? HTTPURLResponse else { return false }
        print("status: ", httpResponse.statusCode )
        if httpResponse.statusCode == 401 {
            return true
        }
        return false
    }
}
