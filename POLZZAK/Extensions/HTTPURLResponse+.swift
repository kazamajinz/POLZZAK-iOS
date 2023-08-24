//
//  HTTPURLResponse+.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/07.
//

import Foundation

extension HTTPURLResponse {
    func getRefreshTokenFromCookie() -> String? {
        guard let cookie = self.allHeaderFields["Set-Cookie"] as? String else { return nil }
        
        let separated = cookie.components(separatedBy: CharacterSet(charactersIn: ";= "))
        for i in 0..<separated.count {
            if separated[i] == "RefreshToken" && i < separated.count - 1 {
                return separated[i+1]
            }
        }
        
        return nil
    }
}
