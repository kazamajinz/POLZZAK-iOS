//
//  Keychain.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/05.
//

import Foundation
import OSLog
import Security

struct Keychain {
    private let service: String
    
    /// init의 service parameter는 의도가 있지 않다면 따로 넣어줄 필요 없음
    init(service: String = Bundle.main.bundleIdentifier!) {
        self.service = service
    }
    
    /// 기존 identifier로 data가 있으면 기존 data를 삭제하고 새 data로 넣어주는 메서드
    func create(identifier: String, value: String) {
        // 1. query작성
        let keychainQuery: NSDictionary = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: identifier,
            kSecValueData: value.data(using: .utf8, allowLossyConversion: false)!
        ]
        // allowLossyConversion은 인코딩 과정에서 손실이 되는 것을 허용할 것인지 설정
        
        // 2. Delete
        // Key Chain은 Key값에 중복이 생기면 저장할 수 없기때문에 먼저 Delete
        SecItemDelete(keychainQuery)
        
        // 3. Create
        let status: OSStatus = SecItemAdd(keychainQuery, nil)
        assert(status == noErr, "failed to saving Token")
    }
    
    func read(identifier: String) -> String? {
        let keychainQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: identifier,
            kSecReturnData: kCFBooleanTrue as AnyObject, // CFData타입으로 불러오라는 의미
            kSecMatchLimit: kSecMatchLimitOne // 중복되는 경우 하나의 값만 가져오라는 의미
        ]
        // CFData 타입 -> AnyObject로 받고, Data로 타입변환해서 사용하면됨
        
        // Read
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        
        // Read 성공 및 실패한 경우
        if(status == errSecSuccess) {
            let retrievedData = dataTypeRef as! Data
            let value = String(data: retrievedData, encoding: String.Encoding.utf8)
            return value
        } else {
            let message = "failed to loading, status code = \(status)"
            os_log("%@", log: .keychain, message)
            return nil
        }
    }
    
    func delete(identifier: String) {
        let keychainQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: identifier
        ]
        
        let status = SecItemDelete(keychainQuery)
        
        guard status != errSecItemNotFound else {
            return
        }
        
        assert(status == noErr, "failed to delete the value, status code = \(status)")
    }
}
