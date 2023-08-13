//
//  UserDefaults+.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/14.
//

import Foundation

extension UserDefaults {
    func setValueEncoded<T: Codable>(_ value: T, forKey key: String) {
        if let encoded = try? JSONEncoder().encode(value) {
            self.setValue(encoded, forKey: key)
        }
    }
    
    func objectDecoded<T: Codable>(type: T.Type, forKey key: String) -> T? {
        if let saved = self.object(forKey: key) as? Data,
           let decoded = try? JSONDecoder().decode(type, from: saved) {
            return decoded
        }
        return nil
    }
    
    func saveUserInfo(_ value: UserInfoDTO.UserInfoWithoutID) {
        self.setValueEncoded(value, forKey: Constants.UserDefaultsKey.userInfo)
    }
    
    func readUserInfo() -> UserInfoDTO.UserInfoWithoutID? {
        return self.objectDecoded(type: UserInfoDTO.UserInfoWithoutID.self, forKey: Constants.UserDefaultsKey.userInfo)
    }
}
