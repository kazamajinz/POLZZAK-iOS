//
//  NotificationServiceTests.swift
//  POLZZAKTests
//
//  Created by 이정환 on 2023/09/21.
//


import XCTest
import Nimble
import Cuckoo
@testable import POLZZAK

class NotificationServiceTests: XCTestCase {
    var service: NotificationService!
    var mockNetworkService: MockNetworkServiceProvider!
    
    override func setUpWithError() throws {
        super.setUp()
        mockNetworkService = MockNetworkServiceProvider()
        service = NotificationService(networkService: mockNetworkService)
    }
    
    override func tearDownWithError() throws {
        mockNetworkService = nil
        service = nil
        super.tearDown()
    }

    // fetchNotificationList 테스트
    func test_알림_목록_올바른_타겟으로_호출_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "NotificationList_200_Sample")
        var capturedTarget: NotificationTargets?

        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target in
                capturedTarget = target as? NotificationTargets
                return (mockResponseData, mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.fetchNotificationList(with: nil)
        
        // Assert
        guard let captured = capturedTarget else {
            fail("Expected NotificationTargets but got \(String(describing: capturedTarget))")
            return
        }
        switch captured {
        case .fetchNotificationList(let startID):
            expect(startID).to(beNil())
        default:
            fail("Expected .fetchNotificationList but got \(captured)")
        }
    }
    
    func test_알림_목록_RequestMethod_의존성_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "NotificationList_200_Sample")
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target in
                return (mockResponseData, mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.fetchNotificationList(with: nil)
        
        // Assert
        verify(mockNetworkService).request(with: any())
    }
    
    func test_알림_목록_네트워크_실패_시_에러_확인() async throws {
        // Arrange
        let (mockResponseData, _) = try TestUtilities.loadMockResponse(from: "Error_400_Sample")
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
        
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).thenReturn((mockResponseData, mockURLResponse))
        }

        // Act & Assert
        await expect { try await self.service.fetchNotificationList(with: nil) }.to(throwError { (error: Error) in
            if case let PolzzakError.serviceError(statusCode) = error {
                expect(statusCode).to(equal(mockURLResponse.statusCode))
            } else {
                fail("Expected PolzzakError.serviceError but got \(error)")
            }
        })
    }

    // removeNotification 테스트
    func test_알림_제거_올바른_타겟으로_호출_확인() async throws {
        // Arrange
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 204, httpVersion: nil, headerFields: nil)!
        var capturedTarget: NotificationTargets?

        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target in
                capturedTarget = target as? NotificationTargets
                return (Data(), mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.removeNotification(with: 1)
        
        // Assert
        guard let captured = capturedTarget else {
            fail("Expected NotificationTargets but got \(String(describing: capturedTarget))")
            return
        }
        switch captured {
        case .removeNotification(let notificationID):
            expect(notificationID).to(equal(1))
        default:
            fail("Expected .removeNotification but got \(captured)")
        }
    }
    
    func test_알림_제거_RequestMethod_의존성_확인() async throws {
        // Arrange
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 204, httpVersion: nil, headerFields: nil)!
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target in
                return (Data(), mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.removeNotification(with: 1)
        
        // Assert
        verify(mockNetworkService).request(with: any())
    }
    
    func test_알림_제거_네트워크_실패_시_에러_확인() async throws {
        // Arrange
        let (mockResponseData, _) = try TestUtilities.loadMockResponse(from: "Error_400_Sample")
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
        
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).thenReturn((mockResponseData, mockURLResponse))
        }

        // Act & Assert
        await expect { try await self.service.removeNotification(with: 1) }.to(throwError { (error: Error) in
            if case let PolzzakError.serviceError(statusCode) = error {
                expect(statusCode).to(equal(mockURLResponse.statusCode))
            } else {
                fail("Expected PolzzakError.serviceError but got \(error)")
            }
        })
    }
}
