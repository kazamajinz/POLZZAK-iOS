//
//  SearchBarStyle.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/13.
//

import UIKit

enum SearchBarStyle {
    case linkManagement(UserType)
    
    var placeholder: String {
        switch self {
        case .linkManagement(let type):
            return "\(type.string) 추가"
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .linkManagement(_):
            return .gray800
        }
    }
    
    var font: UIFont {
        switch self {
        case .linkManagement(_):
            return .systemFont(ofSize: 14)
        }
    }
}
