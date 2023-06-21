//
//  LinkAlertStyle.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/19.
//

import UIKit

enum LinkAlertStyle: AlertStyleProtocol {
    case unlink(String)
    case receivedReject(String)
    case receivedAccept(String)
    case requestCancel(String)
    case linkRequest(String)
    
    var emphasisLabelStyle: EmphasisLabelStyle {
        switch self {
        case .unlink(let nickName):
            let emphasisRange = NSRange(location: 0, length: nickName.count)
            return EmphasisLabelStyle(text: "\(nickName)님과\n연동을 해제하시겠어요?", textColor: .gray700, font: .body7, textAlignment: .center, emphasisRange: emphasisRange, emphasisColor: .gray700, emphasisFont: .body6)
        case .receivedReject(let nickName):
            let emphasisRange = NSRange(location: 0, length: nickName.count)
            return EmphasisLabelStyle(text: "\(nickName)님의\n연동 요청을 거절하시겠어요?", textColor: .gray700, font: .body7, textAlignment: .center, emphasisRange: emphasisRange, emphasisColor: .gray700, emphasisFont: .body6)
        case .receivedAccept(let nickName):
            let emphasisRange = NSRange(location: 0, length: nickName.count)
            return EmphasisLabelStyle(text: "\(nickName)님의\n연동 요청을 수락하시겠어요?", textColor: .gray700, font: .body7, textAlignment: .center, emphasisRange: emphasisRange, emphasisColor: .gray700, emphasisFont: .body6)
        case .requestCancel(let nickName):
            let emphasisRange = NSRange(location: 0, length: nickName.count)
            return EmphasisLabelStyle(text: "\(nickName)님에게 보낸\n연동 요청을 취소하시겠어요?", textColor: .gray700, font: .body7, textAlignment: .center, emphasisRange: emphasisRange, emphasisColor: .gray700, emphasisFont: .body6)
        case .linkRequest(let nickName):
            let emphasisRange = NSRange(location: 0, length: nickName.count)
            return EmphasisLabelStyle(text: "\(nickName)님에게\n연동 오쳥을 보낼까요?", textColor: .gray700, font: .body7, textAlignment: .center, emphasisRange: emphasisRange, emphasisColor: .gray700, emphasisFont: .body6)
        }
    }
    
    var buttonStyle: ButtonCountStyle {
        switch self {
        case .unlink(_), .receivedReject(_), .receivedAccept(_), .requestCancel(_), .linkRequest:
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
        case .linkRequest(_):
            let disagree = LabelStyle(text: "아니요", font: .subtitle3, backgroundColor: .gray300)
            let agree = LabelStyle(text: "네, 좋아요!", font: .subtitle3, backgroundColor: .blue500)
            return [disagree, agree]
        }
    }
    
    var borderStyle: BorderStyle {
        switch self {
        case .unlink(_), .receivedReject(_), .receivedAccept(_), .requestCancel(_), .linkRequest(_):
            return BorderStyle(cornerRadius: 12)
        }
    }
    
    var buttonBorderStyle: BorderStyle {
        switch self {
        case .unlink(_), .receivedReject(_), .receivedAccept(_), .requestCancel(_), .linkRequest(_):
            return BorderStyle(cornerRadius: 8)
        }
    }
    
    var buttonSpacing: CGFloat {
        switch self {
        case .unlink(_), .receivedReject(_), .receivedAccept(_), .requestCancel(_), .linkRequest(_):
            return 11
        }
    }
    
    var isLoading: Bool {
        switch self {
        case .unlink(_), .receivedReject(_), .receivedAccept(_), .requestCancel(_), .linkRequest(_):
            return true
        }
    }
}
