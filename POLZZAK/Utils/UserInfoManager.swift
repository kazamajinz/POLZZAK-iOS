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
    
    static func saveUserInfo(_ value: UserInfoDTO.UserInfo) {
        if let encoded = try? JSONEncoder().encode(value) {
            UserDefaults.standard.setValue(encoded, forKey: Constants.UserDefaultsKey.userInfo)
        }
    }
    
    static func readUserInfo() -> UserInfoDTO.UserInfo? {
        if let saved = UserDefaults.standard.object(forKey: Constants.UserDefaultsKey.userInfo) as? Data,
           let decoded = try? JSONDecoder().decode(UserInfoDTO.UserInfo.self, from: saved) {
            return decoded
        }
        return nil
    }
}
