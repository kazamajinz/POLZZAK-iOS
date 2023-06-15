//
//  TabStyle.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/13.
//

import Foundation

enum TabStyle {
    case linkManagement
    
    var tabConfig: TabConfig {
        switch self {
        case .linkManagement:
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
}
