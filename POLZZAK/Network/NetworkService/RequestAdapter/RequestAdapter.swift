//
//  RequestAdapter.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/30.
//

import Foundation
import OSLog

/// - adapt(for:)을 네트워크 모듈에서 불러줘야 합니다.
/// - adaptTask(for:)을 override해서 adapt를 발생시킬지 정의하세요.
class RequestAdapter {
    /// Adapter가 불러야 하는 함수.
    final func adapt(for urlRequest: inout URLRequest) {
        os_log("adapt", log: .network)
        adaptTask(for: &urlRequest)
    }
    
    /// 유저가 adapt때 실행할 동작을 정의해줘야 하는 함수
    func adaptTask(for urlRequest: inout URLRequest) {
        
    }
}
