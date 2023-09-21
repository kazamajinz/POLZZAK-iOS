//
//  NotificationDataRepositoryTests.swift
//  POLZZAKTests
//
//  Created by 이정환 on 2023/09/21.
//

import XCTest
import Cuckoo
import Nimble

@testable import POLZZAK

class NotificationDataRepositoryTests: XCTestCase {
    var sut: NotificationDataRepository!
    var mockService: MockNotificationService!

    override func setUp() {
        super.setUp()
        mockService = MockNotificationService()
        sut = NotificationDataRepository(notificationService: mockService)
    }

    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }

    // fetchNotificationList 테스트
    func test_fetchNotificationList_서비스_호출_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "NotificationList_200_Sample")
        
        stub(mockService) { mock in
            when(mock.fetchNotificationList(with: any())).thenReturn((mockResponseData, mockURLResponse))
        }

        // Act
        _ = try await sut.fetchNotificationList(with: nil)

        // Assert
        verify(mockService).fetchNotificationList(with: any())
    }

    func test_fetchNotificationList_매핑된_데이터_반환_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "NotificationList_200_Sample")
        let expectedList = TestDataFactory.makSampleNotificationListData()

        stub(mockService) { mock in
            when(mock.fetchNotificationList(with: 1)).thenReturn((mockResponseData, mockURLResponse))
        }

        // Act
        let result = try await sut.fetchNotificationList(with: 1)

        // Assert
        expect(result).to(equal(expectedList))
    }

    func test_fetchNotificationList_서비스_에러_발생_확인() async throws {
        // Arrange
        let (mockResponseData, _) = try TestUtilities.loadMockResponse(from: "Error_400_Sample")
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!

        stub(mockService) { mock in
            when(mock.fetchNotificationList(with: any())).thenReturn((mockResponseData, mockURLResponse))
        }

        // Act & Assert
        await expect { try await self.sut.fetchNotificationList(with: 1) }.to(throwError { (thrownError: Error) in
            switch thrownError {
            case PolzzakError.repositoryError:
                break
            default:
                fail("Expected PolzzakError.repositoryError but got \(thrownError)")
            }
        })
    }

    // removeNotification 테스트
    func test_removeNotification_서비스_호출_확인() async throws {
        // Arrange
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 204, httpVersion: nil, headerFields: nil)!
        
        stub(mockService) { mock in
            when(mock.removeNotification(with: any())).thenReturn((Data(), mockURLResponse))
        }

        // Act
        _ = try await sut.removeNotification(with: 1)

        // Assert
        verify(mockService).removeNotification(with: 1)
    }
}
