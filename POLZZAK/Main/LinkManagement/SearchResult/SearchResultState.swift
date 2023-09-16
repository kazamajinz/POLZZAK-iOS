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
    case linkRequestCompleted(FamilyMember?)
    case nonExist(String)
    case notSearch
}

extension SearchResultState {
    struct Configuration {
        let buttonTitle: String?
        let buttonColor: UIColor?
        let borderColor: UIColor?
        let image: UIImage?
        let placeholder: String?
    }
    
    var configuration: Configuration {
        switch self {
        case .unlinked:
            return Configuration(buttonTitle: "연동요청", buttonColor: .blue500, borderColor: nil, image: nil, placeholder: nil)
        case .linked:
            return Configuration(buttonTitle: "이미 연동됐어요", buttonColor: .gray400, borderColor: .gray400, image: nil, placeholder: nil)
        case .linkRequestCompleted:
            return Configuration(buttonTitle: "연동 요청 완료!", buttonColor: .blue500, borderColor: .blue400, image: nil, placeholder: nil)
        case .nonExist(let nickname):
            return Configuration(buttonTitle: nil, buttonColor: nil, borderColor: nil, image: .sittingCharacter, placeholder: "\(nickname)님을\n찾을 수 없어요")
        case .notSearch:
            return Configuration(buttonTitle: nil, buttonColor: nil, borderColor: nil, image: nil, placeholder: nil)
        }
    }
}
