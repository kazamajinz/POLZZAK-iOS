//
//  StampState.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/05/24.
//

import Foundation

enum StampBoardState {
    case inProgressAndAll
    case inProgressAndSection
    case completedAndAll
    case completedAndSection
    case unknown
}

//TODO: - 타입을 통일할 예정
enum TabState {
    case inProgress
    case completed
}
