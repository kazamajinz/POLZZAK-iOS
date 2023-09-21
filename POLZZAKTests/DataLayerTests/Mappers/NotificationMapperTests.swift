//
//  NotificationMapperTests.swift
//  POLZZAKTests
//
//  Created by 이정환 on 2023/09/21.
//


import XCTest
import Nimble
@testable import POLZZAK

class NotificationMapperTests: XCTestCase {
    
    var mapper: DefaultNotificationMapper!
    
    override func setUp() {
        super.setUp()
        mapper = DefaultNotificationMapper()
    }
    
    override func tearDown() {
        mapper = nil
        super.tearDown()
    }
    
    func test_알림_응답_맵핑_결과_정확성_확인() throws {
        // Arrange
        let response: BaseResponseDTO<NotificationResponseDTO> = try TestUtilities.loadMockResponseDTO(from: "NotificationList_200_Sample")
        
        // Act
        let mappedResponse = mapper.mapNotificationResponse(from: response)
        
        // Assert
        if let data = mappedResponse.data, let notification = data.notificationList?.first {
            expect(notification.id).to(equal(45))
            expect(notification.type).to(equal(.createStampBoard))
            expect(notification.status).to(equal(.read))
            expect(notification.title).to(equal("🥁️️ 새로운 도장판 도착"))
            expect(notification.message).to(equal("'<b>sdf</b>' 도장판이 만들어졌어요. 미션 수행 시~작!"))
            expect(notification.requestFamilyID).to(beNil())
            expect(notification.createdDate).to(equal("2023-09-19T08:46:42"))
        } else {
            fail("예상했던 데이터가 존재하지 않습니다.")
        }
    }
    
    func test_알림_링크_맵핑_결과_정확성_확인() throws {
        // Arrange
        let response: BaseResponseDTO<NotificationResponseDTO> = try TestUtilities.loadMockResponseDTO(from: "NotificationList_200_Sample")
        
        // Act
        let mappedResponse = mapper.mapNotificationResponse(from: response)
        
        // Assert
        if let data = mappedResponse.data, let notification = data.notificationList?.first {
            expect(notification.link).to(equal(.stampBoard(stampBoardID: 20)))
        } else {
            fail("예상했던 데이터가 존재하지 않습니다.")
        }
    }
}

