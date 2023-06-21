//
//  LoadingViewStyle.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/22.
//

import UIKit

enum LoadingViewStyle {
    case linkManagement
    
    var topConstraint: CGFloat {
        switch self {
        case .linkManagement:
            return 251
        }
    }
}
