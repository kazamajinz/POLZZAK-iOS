//
//  BottomSheetState.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/16.
//

import UIKit

enum BottomSheetState {
    case zero
    case half
    case full
    
    var height: CGFloat {
        switch self {
        case .zero:
            return 0
        case .half:
            return (UIApplication.shared.height - UIApplication.shared.statusBarHeight) / 2
        case .full:
            return UIApplication.shared.height - UIApplication.shared.statusBarHeight
        }
    }
    
    var position: CGFloat {
        switch self {
        case .zero:
            return UIApplication.shared.height
        case .half:
            return (UIApplication.shared.height - UIApplication.shared.statusBarHeight) / 2 + UIApplication.shared.statusBarHeight
        case .full:
            return UIApplication.shared.statusBarHeight
        }
    }
}
