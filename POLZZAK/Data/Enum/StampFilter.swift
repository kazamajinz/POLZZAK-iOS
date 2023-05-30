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
