//
//  MemberTypeAPI.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/27.
//

import Foundation

struct MemberTypeAPI {
    typealias APIReturnType = (Data, URLResponse)
    
    static func getMemberTypes() async throws -> APIReturnType {
        do {
            let target = MemberTypeTarget.memberTypes
            let result = try await NetworkService().request(with: target)
            return result
        } catch {
            os_log(log: .polzzakAPI, errorDescription: String(describing: error))
            throw error
        }
    }
}
