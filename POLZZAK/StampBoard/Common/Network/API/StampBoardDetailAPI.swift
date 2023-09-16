//
//  StampBoardDetailAPI.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/09/14.
//

import Foundation

struct StampBoardDetailAPI {
    typealias APIReturnType = (Data, URLResponse)
    
    static func getStampBoardDetail(stampBoardID: Int) async throws -> APIReturnType {
        do {
            let target = StampBoardDetailTarget.get(stampBoardID: stampBoardID)
            let result = try await NetworkService(requestInterceptor: TokenInterceptor()).request(with: target)
            return result
        } catch {
            os_log(log: .polzzakAPI, errorDescription: String(describing: error))
            throw error
        }
    }
}
