//
//  Constants.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/05.
//

// TODO: 앱 출시할때 KeychainKey의 값들을 좀더 임의의 값으로 바꾸기 (2023.06.05)
// TODO: 앱 출시할떄 Constants 파일 .gitignore로 숨기기 (2023.06.05)

enum Constants {
    enum KeychainKey {
        static let accessToken = "accessToken"
        static let refreshToken = "refreshToken"
    }
    
    enum URL {
        static let baseURL = "https://api.polzzak.co.kr/api/"
    }
}
