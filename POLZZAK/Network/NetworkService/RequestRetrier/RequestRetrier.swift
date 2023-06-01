//
//  RequestRetrier.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/30.
//

import Foundation

/// Outcome of determination whether retry is necessary.
enum RetryResult {
    /// Retry should be attempted immediately.
    case retry
    /// Retry should be attempted after the associated `TimeInterval`.
    case retryWithDelay(TimeInterval)
    /// Do not retry.
    case doNotRetry
    /// Do not retry due to the associated `Error`.
    case doNotRetryWithError(Error)
}

extension RetryResult {
    var retryRequired: Bool {
        switch self {
        case .retry, .retryWithDelay: return true
        default: return false
        }
    }

    var delay: TimeInterval? {
        switch self {
        case let .retryWithDelay(delay): return delay
        default: return nil
        }
    }

    var error: Error? {
        guard case let .doNotRetryWithError(error) = self else { return nil }
        return error
    }
}

class RequestRetrier {
    private var retryCount = ThreadSafeDictionary<URLRequest, Int>()
    private let maxRetryCount: Int
    
    init(maxRetryCount: Int = 3) {
        self.maxRetryCount = maxRetryCount
    }
    
    /// Retrier가 불러야 하는 함수. 재귀로 retry 로직이 구현되어있음
    final func retry(_ request: URLRequest, for session: URLSession) async throws -> (Data, URLResponse) {
        guard retryCount[request] == nil || retryCount[request]! < maxRetryCount else {
            retryCount[request] = nil
            let (data, response) = try await session.data(for: request)
            return (data, response)
        }
        
        if retryCount[request] == nil {
            retryCount[request] = 1
        }  else if retryCount[request]! < maxRetryCount {
            retryCount[request]! += 1
        }
        
        var data: Data?
        var response: URLResponse?
        let retryResult: RetryResult
        
        do {
            (data, response) = try await session.data(for: request)
            retryResult = await checkIfRetryIsNeed(for: response, dueTo: nil)
        } catch {
            retryResult = await checkIfRetryIsNeed(for: nil, dueTo: error)
        }
        
        switch retryResult {
        case .retry:
            return try await retry(request, for: session)
        case .retryWithDelay(let seconds):
            try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
            return try await retry(request, for: session)
        case .doNotRetry:
            guard let data, let response else {
                throw NetworkError.doNotRetryButEmptyDataOrResponse
            }
            return (data, response)
        case .doNotRetryWithError(let error):
            throw error
        }
    }
    
    /// 유저가 retry때 실행할 동작을 정의해줘야 하는 함수
    func checkIfRetryIsNeed(for response: URLResponse?, dueTo error: Error?) async -> RetryResult {
        return .doNotRetry
    }
}

final class AuthRetrier: RequestRetrier {
    override func checkIfRetryIsNeed(for response: URLResponse?, dueTo error: Error?) async -> RetryResult {
        // auth 코드
        return .doNotRetry
    }
}
