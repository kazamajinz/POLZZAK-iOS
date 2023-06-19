//
//  AuthAPI.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/10.
//

import Foundation
import OSLog
import UIKit

struct AuthAPI {
    typealias APIReturnType = (Data, URLResponse)
    
    static func login() async throws -> APIReturnType {
        do {
            let oAuthAccessToken = try await KakaoLoginAPI.loginWithKakao()
            print("🪙 oAuthAccessToken", oAuthAccessToken)
            let target = LoginTarget.kakao(oAuthAccessToken: oAuthAccessToken)
            let result = try await NetworkService().request(with: target)
            return result
        } catch {
            OSLog.os_log(log: .userAPI, errorDescription: String(describing: error))
            throw error
        }
    }
    
    static func register(
        username: String,
        socialType: String,
        memberType: Int,
        nickname: String
    ) async throws -> APIReturnType {
        do {
            let target = RegisterTarget.register(username: username, socialType: socialType, memberType: memberType, nickname: nickname)
            let result = try await NetworkService().request(with: target)
            return result
        } catch {
            OSLog.os_log(log: .userAPI, errorDescription: String(describing: error))
            throw error
        }
    }
    
    static func registerWithImage(
        username: String,
        socialType: String,
        memberType: Int,
        nickname: String,
        image: UIImage,
        mimeType: String
    ) async throws -> APIReturnType {
        do {
            let target = RegisterTarget.registerWithImage(username: username, socialType: socialType, memberType: memberType, nickname: nickname, image: image, mimeType: mimeType)
            let result = try await NetworkService().request(with: target)
            return result
        } catch {
            OSLog.os_log(log: .userAPI, errorDescription: String(describing: error))
            throw error
        }
    }
}
