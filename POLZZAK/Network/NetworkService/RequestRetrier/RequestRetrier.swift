//
//  RequestRetrier.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/30.
//

import Foundation
import OSLog

/// - retry(_:for:for:)을 네트워크 모듈에서 불러줘야 합니다.
/// - checkIfRetryIsNeeded(_:for:)을 override해서 retry를 발생시킬지 정의하세요.
class RequestRetrier {
    typealias ResponseType = (Data, URLResponse)
    
    private var retryCount = ThreadSafeDictionary<URLRequest, Int>()
    private let maxRetryCount: Int
    
    init(maxRetryCount: Int = 1) {
        self.maxRetryCount = maxRetryCount
    }
    
    /// Retrier가 불러야 하는 함수. 재귀 함수인 _retry를 내부에서 부른다.
    final func retry(_ request: URLRequest, for session: URLSession, for response: URLResponse) async throws -> ResponseType {
        let retryResult = await checkIfRetryIsNeeded(for: response)
        
        if retryResult.retryRequired {
            if let delay = retryResult.delay {
                try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
            
            guard continueRetry(request) else {
                throw RequestRetrierError.retryImmediatelyEnded
            }
            
            return try await _retry(request, for: session)
        } else {
            if let error = retryResult.error {
                throw error
            }
            
            throw RequestRetrierError.retryImmediatelyEnded
        }
    }
    
    // 재귀 함수.
    private func _retry(_ request: URLRequest, for session: URLSession) async throws -> ResponseType {
        os_log("retry", log: .network)
        let response = try await session.data(for: request)
        let retryResult = await checkIfRetryIsNeeded(for: response.1)
        
        if retryResult.retryRequired {
            if let delay = retryResult.delay {
                try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
            
            guard continueRetry(request) else {
                return response
            }
            
            return try await _retry(request, for: session)
        } else {
            if let error = retryResult.error {
                throw error
            }
            
            return response
        }
    }
    
    private func continueRetry(_ request: URLRequest) -> Bool {
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
    
    /// 유저가 retry때 실행할 동작을 정의해줘야 하는 함수
    func checkIfRetryIsNeeded(for response: URLResponse) async -> RetryResult {
        return .doNotRetry
    }
}

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

enum RequestRetrierError: LocalizedError {
    case retryImmediatelyEnded
    
    var errorDescription: String? {
        switch self {
        case .retryImmediatelyEnded: return "retry가 시작 전 종료되었습니다."
        }
    }
}
