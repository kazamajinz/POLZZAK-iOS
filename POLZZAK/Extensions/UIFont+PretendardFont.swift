//
//  UIFont+PretendardFont.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/14.
//

import UIKit

// MARK: - Pretendard Font

extension UIFont {
    enum FamilyForPretendard: String {
        case bold = "Bold"
        case medium = "Medium"
        case semiBold = "SemiBold"
        case regular = "Regular"
        case extraBold = "ExtraBold"
    }
    
    static func pretendard(size: CGFloat, family: FamilyForPretendard) -> UIFont {
        return UIFont(name: "Pretendard-\(family.rawValue)", size: size)!
    }
}

// MARK: - Project Typo

extension UIFont {
    static var title1: UIFont {
        return .pretendard(size: 24, family: .semiBold)
    }
    
    static var title2: UIFont {
        return .pretendard(size: 22, family: .semiBold)
    }
    
    static var title3: UIFont {
        return .pretendard(size: 20, family: .bold)
    }
    
    static var title4: UIFont {
        return .pretendard(size: 22, family: .bold)
    }
    
    static var subtitle1: UIFont {
        return .pretendard(size: 18, family: .semiBold)
    }
    
    static var subtitle2: UIFont {
        return .pretendard(size: 16, family: .bold)
    }
    
    static var subtitle3: UIFont {
        return .pretendard(size: 16, family: .semiBold)
    }
    
    static var subtitle4: UIFont {
        return .pretendard(size: 20, family: .semiBold)
    }
    
    static var subtitle5: UIFont {
        return .pretendard(size: 20, family: .regular)
    }
    
    static var subtitle6: UIFont {
        return .pretendard(size: 18, family: .regular)
    }
    
    static var body1: UIFont {
        return .pretendard(size: 15, family: .medium)
    }
    
    static var body2: UIFont {
        return .pretendard(size: 14, family: .semiBold)
    }
    
    static var body3: UIFont {
        return .pretendard(size: 14, family: .medium)
    }
    
    static var body4: UIFont {
        return .pretendard(size: 13, family: .medium)
    }
    
    static var body5: UIFont {
        return .pretendard(size: 14, family: .bold)
    }
    
    static var body6: UIFont {
        return .pretendard(size: 18, family: .bold)
    }
    
    static var body7: UIFont {
        return .pretendard(size: 18, family: .medium)
    }
    
    static var body8: UIFont {
        return .pretendard(size: 16, family: .medium)
    }
    
    static var body9: UIFont {
        return .pretendard(size: 13, family: .semiBold)
    }
    
    static var caption1: UIFont {
        return .pretendard(size: 12, family: .semiBold)
    }
    
    static var caption2: UIFont {
        return .pretendard(size: 12, family: .medium)
    }
    
    static var caption3: UIFont {
        return .pretendard(size: 12, family: .bold)
    }
}

// MARK: - New Project Typo

extension UIFont {
    // MARK: - Title
    
    static var title24Sbd: UIFont {
        return .pretendard(size: 24, family: .semiBold)
    }
    
    static var title22Bd: UIFont {
        return .pretendard(size: 22, family: .bold)
    }
    
    static var title22Sbd: UIFont {
        return .pretendard(size: 22, family: .semiBold)
    }
    
    static var title20Bd: UIFont {
        return .pretendard(size: 20, family: .bold)
    }
    
    static var title20Xbd: UIFont {
        return .pretendard(size: 20, family: .extraBold)
    }
    
    // MARK: - Subtitle
    
    static var subtitle20Sbd: UIFont {
        return .pretendard(size: 20, family: .semiBold)
    }
    
    static var subtitle20Rg: UIFont {
        return .pretendard(size: 20, family: .regular)
    }
    
    static var subtitle18Sbd: UIFont {
        return .pretendard(size: 18, family: .semiBold)
    }
    
    static var subtitle18Rg: UIFont {
        return .pretendard(size: 18, family: .regular)
    }
    
    static var subtitle16Bd: UIFont {
        return .pretendard(size: 16, family: .bold)
    }
    
    static var subtitle16Sbd: UIFont {
        return .pretendard(size: 16, family: .semiBold)
    }
    
    static var subtitle16Md: UIFont {
        return .pretendard(size: 16, family: .medium)
    }
    
    // MARK: - Body
    
    static var body18Bd: UIFont {
        return .pretendard(size: 18, family: .bold)
    }
    
    static var body18Md: UIFont {
        return .pretendard(size: 18, family: .medium)
    }
    
    static var body16Md: UIFont {
        return .pretendard(size: 16, family: .medium)
    }
    
    static var body15Md: UIFont {
        return .pretendard(size: 15, family: .medium)
    }
    
    static var body14Bd: UIFont {
        return .pretendard(size: 14, family: .bold)
    }
    
    static var body14Sbd: UIFont {
        return .pretendard(size: 14, family: .semiBold)
    }
    
    static var body14Md: UIFont {
        return .pretendard(size: 14, family: .medium)
    }
    
    static var body13Md: UIFont {
        return .pretendard(size: 13, family: .medium)
    }
    
    static var body13Sbd: UIFont {
        return .pretendard(size: 13, family: .semiBold)
    }
    
    // MARK: - Caption
    
    static var caption13Sbd: UIFont {
        return .pretendard(size: 13, family: .semiBold)
    }
    
    static var caption12Bd: UIFont {
        return .pretendard(size: 12, family: .bold)
    }
    
    static var caption12Sbd: UIFont {
        return .pretendard(size: 12, family: .semiBold)
    }
    
    static var caption12Md: UIFont {
        return .pretendard(size: 12, family: .medium)
    }
}
