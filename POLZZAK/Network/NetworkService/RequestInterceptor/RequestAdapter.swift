//
//  RequestAdapter.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/30.
//

import Foundation
import OSLog

protocol RequestAdapter {
    func adapt(for urlRequest: URLRequest) async throws -> URLRequest
}
