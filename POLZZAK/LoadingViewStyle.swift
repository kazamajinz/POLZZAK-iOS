//
//  LoadingViewStyle.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/22.
//

import UIKit

enum LoadingViewStyle {
    case linkmanagement
    
    var topConstraint: CGFloat {
        switch self {
        case .linkmanagement:
            return 251
        }
    }
}
