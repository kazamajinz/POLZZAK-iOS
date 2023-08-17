//
//  StampFilter.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/05/26.
//

import Foundation

enum StampFilter {
    case all
    case section(StampSection)
}

struct StampSection {
    let id: Int
    let name: String
    let memberType: String
}

//TODO: - 타입을 통일할 예정
enum FilterType {
    case all
    case section(Int)
}

extension FilterType: Equatable {
    static func == (lhs: FilterType, rhs: FilterType) -> Bool {
        switch (lhs, rhs) {
        case (.all, .all):
            return true
        case let (.section(leftMember), .section(rightMember)):
            return leftMember == rightMember
        default:
            return false
        }
    }
}
