//
//  ButtonStyle.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/20.
//

import UIKit

enum ButtonStyle {
    case ModalBlue500
    case ModalGray300
    case AcceptBlue500
    case RejectError500
    case LinkRequestBlue500
    case Gray400White
    
    var textColor: UIColor {
        switch self {
        case .ModalBlue500:
            return .white
        case .ModalGray300:
            return .white
        case .AcceptBlue500:
            return .white
        case .RejectError500:
            return .white
        case .LinkRequestBlue500:
            return .white
        case .Gray400White:
            return .gray400
        }
    }
    
    var font: UIFont {
        switch self {
        case .ModalBlue500:
            return .subtitle3
        case .ModalGray300:
            return .subtitle3
        case .AcceptBlue500:
            return .subtitle3
        case .RejectError500:
            return .subtitle3
        case .LinkRequestBlue500:
            return .caption3
        case .Gray400White:
            return .caption3
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .ModalBlue500:
            return .blue500
        case .ModalGray300:
            return .gray300
        case .AcceptBlue500:
            return .blue500
        case .RejectError500:
            return .error500
        case .LinkRequestBlue500:
            return .blue500
        case .Gray400White:
            return .white
        }
    }
    
    var borderColor: CGColor {
        switch self {
        case .ModalBlue500:
            return UIColor.clear.cgColor
        case .ModalGray300:
            return UIColor.clear.cgColor
        case .AcceptBlue500:
            return UIColor.clear.cgColor
        case .RejectError500:
            return UIColor.clear.cgColor
        case .LinkRequestBlue500:
            return UIColor.clear.cgColor
        case .Gray400White:
            return UIColor.gray400.cgColor
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .ModalBlue500:
            return 8
        case .ModalGray300:
            return 8
        case .AcceptBlue500:
            return 6
        case .RejectError500:
            return 6
        case .LinkRequestBlue500:
            return 4
        case .Gray400White:
            return 4
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .ModalBlue500:
            return 0
        case .ModalGray300:
            return 0
        case .AcceptBlue500:
            return 0
        case .RejectError500:
            return 0
        case .LinkRequestBlue500:
            return 0
        case .Gray400White:
            return 1
        }
    }
}
