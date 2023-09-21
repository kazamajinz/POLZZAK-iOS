//
//  BottomSheetState.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/16.
//

import UIKit

enum BottomSheetState {
    case zero
    case short(height: CGFloat)
    case full
    
    var height: CGFloat {
        switch self {
        case .zero:
            return 0
        case .short(let height):
            return height
        case .full:
            return UIApplication.shared.height - UIApplication.shared.statusBarHeight
        }
    }
    
    var position: CGFloat {
        switch self {
        case .zero:
            return UIApplication.shared.height
        case .short(let height):
            return UIApplication.shared.height - height
        case .full:
            return UIApplication.shared.statusBarHeight
        }
    }
}
