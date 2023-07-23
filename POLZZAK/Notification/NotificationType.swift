//
//  NotificationType.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/07/12.
//

import UIKit

//TODO: - 네이밍은 서버에서 정한대로 바꿀 예정, 서버에서 부모관계를 타입으로 줬었기 때문에 이번에도 그럴것으로 예상됨. 안되면 요청할 예정.
enum NotificationType: String, CaseIterable {
    case requestLink = "requestLink"
    case completedLink = "completedLink"
    case levelUp = "levelUp"
    case levelDown = "levelDown"
    case requestStamp = "requestStamp"
    case requestReward = "requestReward"
    case completedStampBoard = "completedStampBoard"
    case receivedReward = "receivedReward"
    case oneDayLeftReward = "oneDayLeftReward"
    case brokenReward = "brokenReward"
    case createStampBoard = "createStampBoard"
    case receivedCoupon = "receivedCoupon"
    case requestCompleteTap = "requestCompleteTap"
    
    var title: (String, String) {
        switch self {
        case .requestLink:
            return ("💌", "연동 요청")
        case .completedLink:
            return ("🤝🏻", "연동 완료")
        case .levelUp:
            return ("🥳", "레벨 UP")
        case .levelDown:
            return ("🚨", "레벨 DOWN")
        case .requestStamp:
            return ("✊🏻", "도장 요청")
        case .requestReward:
            return ("⚡️", "선물 조르기")
        case .completedStampBoard:
            return ("✔️️", "도장판 채우기 완료")
        case .receivedReward:
            return ("🎁️️", "선물 받기 완료")
        case .oneDayLeftReward:
            return ("⏱️️", "선물 약속 날짜 D-1")
        case .brokenReward:
            return ("☠️️️", "선물 약속 어김")
        case .createStampBoard:
            return ("🥁️️", "새로운 도장판 도착")
        case .receivedCoupon:
            return ("🎟️️", "쿠폰 발급 완료")
        case .requestCompleteTap:
            return ("🎁️️", "혹시 선물은 잘 받았나요?")
        }
    }
    
    var isButtonHidden: Bool {
        switch self {
        case .requestLink:
            return false
        default:
            return true
        }
    }
    
    var isSenderHidden: Bool {
        switch self {
        case .levelUp, .levelDown, .requestCompleteTap:
            return false
        default:
            return true
        }
    }
    
    func getStyle(emphasisText: String) -> EmphasisLabelStyle {
        let emphasisRangeArray: [NSRange]
        let text: String
        
        switch self {
        case .requestLink:
            emphasisRangeArray = [NSRange(location: 0, length: emphasisText.count)]
            text = "\(emphasisText)님이 회원님께 연동 요청을 보냈어요"
        case .completedLink:
            emphasisRangeArray = [NSRange(location: 0, length: emphasisText.count)]
            text = "\(emphasisText)님과 연동이 완료되었어요! 도장판을 만들러 가볼까요? :)"
        case .levelUp:
            let levelText = emphasisText + "계단"
            emphasisRangeArray = [NSRange(location: 4, length: levelText.count)]
            text = "폴짝! \(levelText)으로 올라갔어요!"
        case .levelDown:
            let levelText = emphasisText + "계단"
            emphasisRangeArray = [NSRange(location: 4, length: levelText.count)]
            text = "조심! \(levelText)으로 내려왔어요"
        case .requestStamp:
            emphasisRangeArray = [NSRange(location: 1, length: emphasisText.count)]
            text = "‘\(emphasisText)’ 도장판에 도장을 찍어주세요!"
        case .requestReward:
            emphasisRangeArray = [NSRange(location: 1, length: emphasisText.count)]
            text = "‘\(emphasisText)’ 선물을 얼른 받고 싶어요!"
        case .completedStampBoard:
            emphasisRangeArray = [NSRange(location: 1, length: emphasisText.count)]
            text = "‘\(emphasisText)’ 도장판에 도장이 다 모였어요\n선물 쿠폰을 발급해주세요!"
        case .receivedReward:
            emphasisRangeArray = [NSRange(location: 1, length: emphasisText.count)]
            text = "‘\(emphasisText)’ 선물 받기 완료! 선물을 주셔서 감사합니다 ❤️"
        case .oneDayLeftReward:
            emphasisRangeArray = [NSRange(location: 8, length: emphasisText.count)]
            text = "잊지마세요! ‘\(emphasisText)’ 선물을 주기로 한 날짜가 하루 남았어요"
        case .brokenReward:
            emphasisRangeArray = [NSRange(location: 9, length: emphasisText.count)]
            text = "실망이에요.. ‘\(emphasisText)’ 선물 약속을 어기셨어요"
        case .createStampBoard:
            emphasisRangeArray = [NSRange(location: 1, length: emphasisText.count)]
            text = "‘\(emphasisText)’ 도장판이 만들어졌어요. 미션 수행 시~작!"
        case .receivedCoupon:
            emphasisRangeArray = [NSRange(location: 1, length: emphasisText.count)]
            text = "‘\(emphasisText)’ 도장판에 선물 쿠폰이 도착했어요! 쿠폰을 받으러 가볼까요?"
        case .requestCompleteTap:
            emphasisRangeArray = [
                NSRange(location: 1, length: emphasisText.count),
                NSRange(location: 70 + emphasisText.count, length: 4)]
            text = "‘\(emphasisText)’ 선물을 실제로 전달 받았나요? 선물을 받았다면 쿠폰에서 ‘선물 받기 완료’ 버튼을 꼭 눌러주세요!\n누르지 않으면 보호자는 100P가 깎여요"
        }
        
        let builder = LabelStyleBuilder()
        let style = builder.setText(text)
            .setTextColor(.gray700)
            .setFont(.body2)
            .setTextAlignment(.natural)
            .setEmphasisRangeArray(emphasisRangeArray)
            .setEmphasisColor(.gray800)
            .setEmphasisFont(.body2)
            .build()
        return style
    }
}
