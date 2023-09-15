//
//  Constants.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/06.
//

// TODO: 앱 출시할때 KeychainKey의 값들을 좀더 임의의 값으로 바꾸기 (2023.06.05)
// TODO: 앱 출시할때 Constants 파일 gitignore에 추가하기

enum Constants {
    enum KakaoKey {
        static let nativeAppKey = "4c022153e5265c04e1050b2098179206"
    }
    
    enum KeychainKey {
        static let accessToken = "accessToken"
        static let refreshToken = "refreshToken"
        static let registerUsername = "registerUsername"
        static let registerSocialType = "registerSocialType"
    }
    
    enum UserDefaultsKey {
        static let userInfo = "UserDefaultsUserInfo"
    }
    
    enum URL {
        static let baseURL = "https://api.polzzak.co.kr/api/"
        static let localURL = "http://localhost:3000/"
    }
}
