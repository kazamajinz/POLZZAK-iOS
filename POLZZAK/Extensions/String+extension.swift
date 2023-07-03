//
//  String+extension.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/24.
//

import Foundation

extension String {
    func getRefreshTokenFromCookie() -> String? {
        let separated = self.components(separatedBy: CharacterSet(charactersIn: ";= "))
        for i in 0..<separated.count {
            if separated[i] == "RefreshToken" && i < separated.count - 1 {
                return separated[i+1]
            }
        }
        return nil
    }
}
