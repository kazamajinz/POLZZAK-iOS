//
//  RequestRetrier.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/30.
//

import Foundation
import OSLog

protocol RequestRetrier {
    var maxRetryCount: Int { get }
    func retry(previousData: Data, response: URLResponse) async throws -> RetryResult
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
