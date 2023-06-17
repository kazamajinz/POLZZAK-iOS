//
//  AuthAPI.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/10.
//

import Foundation

struct AuthAPI {
    // TODO: print 지우기
    static func login() async throws -> (Data, URLResponse) {
        do {
            let oAuthAccessToken = try await KakaoLoginAPI.loginWithKakao()
            print("🪙 oAuthAccessToken", oAuthAccessToken)
            let target = LoginTarget.kakao(oAuthAccessToken: oAuthAccessToken)
            let (data, response) = try await NetworkService().request(with: target)
            return (data, response)
        } catch {
            print("🟢 just print error: ", error)
            print("🔵 string describing error: ", String(describing: error))
            throw error
        }
    }
}
