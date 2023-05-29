//
//  URLSessionProvider.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/29.
//

import Foundation

/// URLSession 테스트를 위한 protocol (Provider 생성자에서 해당 인터페이스 참조)
protocol URLSessionProvider {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProvider {}
