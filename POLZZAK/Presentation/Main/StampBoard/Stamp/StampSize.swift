//
//  StampSize.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/22.
//

enum StampSize: CaseIterable {
    case size10, size12, size16, size20
    case size25, size30, size36
    case size40, size48, size60
    
    var count: Int {
        return rawValue.count
    }
    
    var reducedCount: Int {
        guard let reducedCount = rawValue.reducedCount else {
            return count
        }
        return reducedCount
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
    
    var isMoreStatus: Bool {
        if let _ = rawValue.reducedCount {
            return true
        } else {
            return false
        }
    }
}

extension StampSize: RawRepresentable {
    typealias RawValue = (count: Int, reducedCount: Int?)
    
    init?(rawValue: RawValue) {
        switch rawValue {
        case (10, nil):
            self = .size10
        case (12, nil):
            self = .size12
        case (16, nil):
            self = .size16
        case (20, nil):
            self = .size20
        case (25, nil):
            self = .size25
        case (30, nil):
            self = .size30
        case (36, nil):
            self = .size36
        case (40, 20):
            self = .size40
        case (48, 30):
            self = .size48
        case (60, 30):
            self = .size60
        default:
            return nil
        }
    }
    
    var rawValue: RawValue {
        switch self {
        case .size10:
            return (10, nil)
        case .size12:
            return (12, nil)
        case .size16:
            return (16, nil)
        case .size20:
            return (20, nil)
        case .size25:
            return (25, nil)
        case .size30:
            return (30, nil)
        case .size36:
            return (36, nil)
        case .size40:
            return (40, 20)
        case .size48:
            return (48, 30)
        case .size60:
            return (60, 30)
        }
    }
}

extension StampSize {
    /// For convenience
    init?(count: Int) {
        switch count {
        case 10:
            self = .size10
        case 12:
            self = .size12
        case 16:
            self = .size16
        case 20:
            self = .size20
        case 25:
            self = .size25
        case 30:
            self = .size30
        case 36:
            self = .size36
        case 40:
            self = .size40
        case 48:
            self = .size48
        case 60:
            self = .size60
        default:
            return nil
        }
    }
}
