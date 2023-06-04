//
//  RequestAdapter.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/30.
//

import Foundation

protocol RequestAdapter {
    func adapt(for urlRequest: inout URLRequest)
}
