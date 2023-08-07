//
//  SearchResultState.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/21.
//

import UIKit

enum SearchResultState {
    case unlinked(FamilyMember)
    case linked(FamilyMember)
    case linkedRequestComplete(FamilyMember)
    case nonExist(String)
    case notSearch
}

extension SearchResultState: Equatable {
    static func == (lhs: SearchResultState, rhs: SearchResultState) -> Bool {
        switch (lhs, rhs) {
        case (.unlinked, .unlinked),
            (.linked, .linked),
            (.nonExist, .nonExist),
            (.notSearch, .notSearch):
            return true
        default:
            return false
        }
    }
}
