//
//  LinkSearchEmptyStyle.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/19.
//

import UIKit

enum LinkSearchEmptyStyle: EmptyStyleProtocol {
    case searchDefault(UserType)
    
    var labelStyle: LabelStyleProtocol {
        switch self {
        case .searchDefault(let type):
            let userType = (type == .parent ? "보호자" : "아이")
            return LabelStyle(text: "연동된 \(userType)에게\n칭안 도장판을 만들어 줄 수 있어요", textColor: .gray500, font: .caption2, textAlignment: .center)
        }
    }
    
    var topConstraint: CGFloat {
        switch self {
        case .searchDefault(_):
            return 229
        }
    }
    
    var emptyImage: UIImage? {
        switch self {
        case .searchDefault(_):
            return UIImage.searchImage
        }
        
    }
    
    
}
