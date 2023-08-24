//
//  UserAPI.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/14.
//

import Foundation

struct UserAPI {
    typealias APIReturnType = (Data, URLResponse)
    
    static func getUserInfo() async throws -> APIReturnType {
        do {
            let target = UserInfoTarget.getUserInfo
            let result = try await NetworkService(requestInterceptor: UserInfoInterceptor()).request(with: target)
            return result
        } catch {
            os_log(log: .polzzakAPI, errorDescription: String(describing: error))
            throw error
        }
    }
}
