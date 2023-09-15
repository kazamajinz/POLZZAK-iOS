//
//  SearchState.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/20.
//

import Foundation

//enum SearchState {
//    case beforeSearch(isSearchBarActive: Bool? = nil)
//    case searching(nickName: String? = nil)
//    case afterSearch
//}
//
//extension SearchState: Equatable {
//    static func == (lhs: SearchState, rhs: SearchState) -> Bool {
//        switch (lhs, rhs) {
//        case (.beforeSearch, .beforeSearch),
//            (.searching, .searching),
//            (.afterSearch, .afterSearch):
//            return true
//        default:
//            return false
//        }
//    }
//}

enum SearchState {
    case inactive        // 검색창 비활성화
    case activated       // 검색창 활성화
    case searching(String)       // 검색 중
    case completed       // 검색 완료
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
