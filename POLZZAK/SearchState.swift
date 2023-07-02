//
//  SearchState.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/20.
//

import Foundation

enum SearchState {
    case beforeSearch(isSearchBarActive: Bool? = nil)
    case searching(nickName: String? = nil)
    case afterSearch
}

extension SearchState: Equatable {
    static func == (lhs: SearchState, rhs: SearchState) -> Bool {
        switch (lhs, rhs) {
        case (.beforeSearch, .beforeSearch),
            (.searching, .searching),
            (.afterSearch, .afterSearch):
            return true
        default:
            return false
        }
    }
}
