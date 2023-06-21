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
    case nonExist(String)
    case notSearch
    
    var imageURL: String {
        switch self {
        case .unlinked(let member):
            return member.profileURL
        case .linked(let member):
            return member.profileURL
        case .nonExist(_):
            return ""
        case .notSearch:
            return ""
        }
    }
    
    var placeholder: LabelStyleProtocol? {
        switch self {
        case .unlinked(let member):
            let nickName = member.nickName
            return LabelStyle(text: nickName, textColor: .black, font: .body5)
        case .linked(let member):
            let nickName = member.nickName
            return LabelStyle(text: nickName, textColor: .black, font: .body5)
        case .nonExist(let nickName):
            let emphasisRange = NSRange(location: 0, length: nickName.count)
            let emphasisLabelStyle = EmphasisLabelStyle(text: "\(nickName)님을\n찾을 수 없어요", textColor: .gray700, font: .body3, textAlignment: .center, emphasisRange: emphasisRange, emphasisColor: .gray700, emphasisFont: .body5)
            return emphasisLabelStyle
        case .notSearch:
            return nil
        }
    }
    
    var imageViewSize: CGFloat {
        switch self {
        case .unlinked(_):
            return 91
        case .linked(_):
            return 91
        case .nonExist(_):
            return 100
        case .notSearch:
            return 0
        }
    }
    
    var buttonWidth: CGFloat {
        switch self {
        case .unlinked(_):
            return 93
        case .linked(_):
            return 124
        case .nonExist(_):
            return 0
        case .notSearch:
            return 0
        }
    }
    
    var cornerRadious: CGFloat {
        switch self {
        case .unlinked(_):
            return 45.5
        case .linked(_):
            return 45.5
        case .nonExist(_):
            return 50
        case .notSearch:
            return 0
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .unlinked(_):
            return "연동요청"
        case .linked(_):
            return "이미 연동됐어요"
        case .nonExist(_):
            return ""
        case .notSearch:
            return ""
        }
    }
    
    var buttonStyle: ButtonStyle? {
        switch self {
        case .unlinked(_):
            return .LinkRequestBlue500
        case .linked(_):
            return .Gray400White
        case .nonExist(_):
            return nil
        case .notSearch:
            return nil
        }
    }
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
