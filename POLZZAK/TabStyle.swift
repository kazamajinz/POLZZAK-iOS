//
//  TabStyle.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/13.
//

import Foundation

enum TabStyle {
    case linkListTab
    case receivedTab
    case sentTab
    
    var tabConfig: TabConfig {
        switch self {
        case .linkListTab:
            return TabConfig(
                textArray: ["연동 목록", "받은 요청", "보낸 요청"],
                textColor: .gray300,
                font: .subtitle2,
                lineColor: .gray300,
                lineHeight: 2.0,
                selectTextColor: .blue500,
                selectLineColor: .blue500,
                selectLineHeight: 2.0
            )
        case .receivedTab:
            return TabConfig(
                textArray: ["연동 목록", "받은 요청", "보낸 요청"],
                textColor: .gray300,
                font: .subtitle2,
                lineColor: .gray300,
                lineHeight: 2.0,
                selectTextColor: .blue500,
                selectLineColor: .blue500,
                selectLineHeight: 2.0
            )
        case .sentTab:
            return TabConfig(
                textArray: ["연동 목록", "받은 요청", "보낸 요청"],
                textColor: .gray300,
                font: .subtitle2,
                lineColor: .gray300,
                lineHeight: 2.0,
                selectTextColor: .blue500,
                selectLineColor: .blue500,
                selectLineHeight: 2.0
            )
        }
    }
    
    var labelStyle: LabelStyle {
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
        //MARK: - 센터 고정시 0으로 줄것.
        switch self {
        case .linkListTab, .receivedTab, .sentTab:
            return 128
        }
    }
}
