//
//  AlertStyle.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/15.
//

import UIKit

protocol AlertStyle {
    var emphasisLabelStyle: EmphasisLabelStyle { get }
    var buttonStyle: ButtonStyle { get }
    var buttons: [LabelStyle] { get }
    var borderStyle: BorderStyle { get }
    var buttonBorderStyle: BorderStyle { get }
    var buttonSpacing: CGFloat { get }
    var isLoading: Bool { get }
}


enum ButtonStyle {
    case single
    case double
}

enum UnlinkAlertStyle: AlertStyle {
    case unlink(String)
    case receivedReject(String)
    case receivedAccept(String)
    case requestCancel(String)
    
    var emphasisLabelStyle: EmphasisLabelStyle {
        switch self {
        case .unlink(let nickName):
            return EmphasisLabelStyle(text: nickName, textFont: .body6, textColor: .gray700, rest: "님과\n연동을 해제하시겠어요?", restFont: .body7, restColor: .gray700, textAlignment: .center)
        case .receivedReject(let nickName):
            return EmphasisLabelStyle(text: nickName, textFont: .body6, textColor: .gray700, rest: "님의\n연동 요청을 거절하시겠어요?", restFont: .body7, restColor: .gray700, textAlignment: .center)
        case .receivedAccept(let nickName):
            return EmphasisLabelStyle(text: nickName, textFont: .body6, textColor: .gray700, rest: "님의\n연동 요청을 수락하시겠어요?", restFont: .body7, restColor: .gray700, textAlignment: .center)
        case .requestCancel(let nickName):
            return EmphasisLabelStyle(text: nickName, textFont: .body6, textColor: .gray700, rest: "님에게 보낸\n연동 요청을 취소하시겠어요?", restFont: .body7, restColor: .gray700, textAlignment: .center)
        }
    }
    
    var buttonStyle: ButtonStyle {
        switch self {
        case .unlink(_), .receivedReject(_), .receivedAccept(_), .requestCancel(_):
            return .double
        }
    }
    
    var buttons: [LabelStyle] {
        switch self {
        case .unlink(_):
            let disagree = LabelStyle(text: "아니요", font: .subtitle3, backgroundColor: .gray300)
            let agree = LabelStyle(text: "네, 해제할래요", font: .subtitle3, backgroundColor: .blue500)
            return [disagree, agree]
        case .receivedReject(_):
            let disagree = LabelStyle(text: "아니요", font: .subtitle3, backgroundColor: .gray300)
            let agree = LabelStyle(text: "네, 거절할래요", font: .subtitle3, backgroundColor: .blue500)
            return [disagree, agree]
        case .receivedAccept(_):
            let disagree = LabelStyle(text: "아니요", font: .subtitle3, backgroundColor: .gray300)
            let agree = LabelStyle(text: "네, 좋아요!", font: .subtitle3, backgroundColor: .blue500)
            return [disagree, agree]
        case .requestCancel(_):
            let disagree = LabelStyle(text: "아니요", font: .subtitle3, backgroundColor: .gray300)
            let agree = LabelStyle(text: "네, 취소할래요", font: .subtitle3, backgroundColor: .blue500)
            return [disagree, agree]
        }
    }
    
    var borderStyle: BorderStyle {
        switch self {
        case .unlink(_), .receivedReject(_), .receivedAccept(_), .requestCancel(_):
            return BorderStyle(cornerRadius: 12)
        }
    }
    
    var buttonBorderStyle: BorderStyle {
        switch self {
        case .unlink(_), .receivedReject(_), .receivedAccept(_), .requestCancel(_):
            return BorderStyle(cornerRadius: 8)
        }
    }
    
    var buttonSpacing: CGFloat {
        switch self {
        case .unlink(_), .receivedReject(_), .receivedAccept(_), .requestCancel(_):
            return 11
        }
    }
    
    var isLoading: Bool {
        switch self {
        case .unlink(_), .receivedReject(_), .receivedAccept(_), .requestCancel(_):
            return true
        }
    }
}
