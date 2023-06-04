//
//  AuthRetrier.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/04.
//

import Foundation

final class AuthRetrier: RequestRetrier {
    override func checkIfRetryIsNeeded(for response: URLResponse) async -> RetryResult {
        return .retry
    }
}
