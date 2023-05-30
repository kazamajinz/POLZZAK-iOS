//
//  TokenEndpoints.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/30.
//

import Foundation

struct TokenEndpoints {
    static func authorize() -> Endpoint<TokenResponseDTO> {
        return Endpoint(baseURL: "https://api.polzzak.co.kr/", path: "api/v1/users/me", method: .get)
    }
}
