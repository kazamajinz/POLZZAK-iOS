//
//  SearchState.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/20.
//

import Foundation

enum SearchState {
    case inactive
    case activated
    case searching(String)
    case completed
}

extension SearchState: Equatable {
    static func == (lhs: SearchState, rhs: SearchState) -> Bool {
        switch (lhs, rhs) {
        case (.inactive, .inactive),
            (.activated, .activated),
            (.searching, .searching),
            (.completed, .completed):
            return true
        default:
            return false
        }
    }
}
