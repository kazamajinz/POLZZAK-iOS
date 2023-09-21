//
//  UserInfoManager.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/19.
//

import Foundation

final class UserInfoManager {
    
    // MARK: - Keychain
    
    enum TokenType {
        case access
        case refresh
        
        var keychainKey: String {
            switch self {
            case .access:
                return Constants.KeychainKey.accessToken
            case .refresh:
                return Constants.KeychainKey.refreshToken
            }
        }
    }
    
    // MARK: Token
    
    static func saveToken(_ token: String, type: TokenType) {
        Keychain().create(identifier: type.keychainKey, value: token)
    }
    
    static func readToken(type: TokenType) -> String? {
        return Keychain().read(identifier: type.keychainKey)
    }
    
    static func deleteToken(type: TokenType) {
        Keychain().delete(identifier: type.keychainKey)
    }
    
    // MARK: RegisterInfo
    
    static func saveRegisterInfo(username: String, socialType: String) {
        Keychain().create(identifier: Constants.KeychainKey.registerUsername, value: username)
        Keychain().create(identifier: Constants.KeychainKey.registerSocialType, value: socialType)
    }
    
    static func readRegisterInfo() -> (username: String, socialType: String)? {
        guard let username = Keychain().read(identifier: Constants.KeychainKey.registerUsername),
              let socialType = Keychain().read(identifier: Constants.KeychainKey.registerSocialType)
        else {
            return nil
        }
        return (username, socialType)
    }
    
    static func deleteRegisterInfo() {
        Keychain().delete(identifier: Constants.KeychainKey.registerUsername)
        Keychain().delete(identifier: Constants.KeychainKey.registerSocialType)
    }
    
    // MARK: - UserDefaults
    
    // TODO: UserInfoDTO 직접 사용하지 말고 Domain Object로 변환해서 사용하도록 고치기
    static func saveUserInfo(_ value: UserInfoDTO.UserInfo) {
        if let encoded = try? JSONEncoder().encode(value) {
            UserDefaults.standard.setValue(encoded, forKey: Constants.UserDefaultsKey.userInfo)
        }
    }
    
    // TODO: UserInfoDTO 직접 사용하지 말고 Domain Object로 변환해서 사용하도록 고치기
    static func readUserInfo() -> UserInfoDTO.UserInfo? {
        if let saved = UserDefaults.standard.object(forKey: Constants.UserDefaultsKey.userInfo) as? Data,
           let decoded = try? JSONDecoder().decode(UserInfoDTO.UserInfo.self, from: saved) {
            return decoded
        }
        return nil
    }
    
    /// 첫 실행이면 남아있는 token 정보를 삭제한다
    /// - 앱이 재설치 되었을 경우에 키체인에 토큰 정보가 남아있을 수 있으므로, 삭제하는 로직이 들어가 있음
    static func checkFirstLaunch() {
        let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
        if isFirstLaunch {
            deleteToken(type: .access)
            deleteToken(type: .refresh)
            UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
        }
    }
}
