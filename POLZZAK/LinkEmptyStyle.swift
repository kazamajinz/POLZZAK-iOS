//
//  LinkEmptyStyle.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/19.
//

import UIKit

enum LinkEmptyStyle: EmptyStyleProtocol {
    case linkListTab
    case receivedTab
    case sentTab
    
    var labelStyle: LabelStyleProtocol {
        switch self {
        case .linkListTab:
            return LabelStyle(text: "연동된 아이가 없어요", textColor: .gray700, font: .body3)
        case .receivedTab:
            return LabelStyle(text: "받은 요청이 없어요", textColor: .gray700, font: .body3)
        case .sentTab:
            return LabelStyle(text: "보낸 요청이 없어요", textColor: .gray700, font: .body3)
        }
    }

    var topConstraint: CGFloat {
        return 128
    }
    
    var emptyImage: UIImage? {
        return .sittingCharacter
    }
}
