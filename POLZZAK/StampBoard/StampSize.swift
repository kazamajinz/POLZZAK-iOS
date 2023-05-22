//
//  StampSize.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/22.
//

enum StampSize: Int {
    case size10 = 10, size12 = 12, size16 = 16, size20 = 20
    case size25 = 25, size30 = 30, size36 = 36
    case size40 = 40, size48 = 48, size60 = 60
    
    var numberOfItems: Int {
        return self.rawValue
    }
    
    var numberOfItemsPerLine: Int {
        switch self {
        case .size10, .size12, .size16, .size20:
            return 4
        case .size25, .size30, .size40:
            return 5
        case .size36, .size48, .size60:
            return 6
        }
    }
    
    var showMoreStamp: ShowMoreStamp {
        switch self {
        case .size40, .size48, .size60:
            return .yes
        default:
            return .none
        }
    }
}
