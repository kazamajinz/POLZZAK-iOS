//
//  UserType.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/19.
//

import Foundation

enum UserType {
    case parent
    case child
    
    var string: String {
        switch self {
        case .parent:
            return "보호자"
        case .child:
            return "아이"
        }
    }
}
