//
//  ToastType.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/03.
//

import UIKit

enum ToastType: Equatable {
    case success(String, UIImage? = nil)
    case error(String, UIImage? = nil)
    case qatest(String, UIImage? = nil)
    
    static func == (lhs: ToastType, rhs: ToastType) -> Bool {
        switch (lhs, rhs) {
        case (.success, .success), (.error, .error), (.qatest, .qatest):
            return true
        default:
            return false
        }
    }
}
