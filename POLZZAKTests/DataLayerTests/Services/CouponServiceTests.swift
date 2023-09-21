//
//  CouponServiceTests.swift
//  POLZZAKTests
//
//  Created by 이정환 on 2023/09/21.
//

@testable import POLZZAK

import XCTest
import Nimble
import Cuckoo

class CouponServiceTests: XCTestCase {
    var service: CouponService!
    var mockNetworkService: MockNetworkServiceProvider!
    
    override func setUpWithError() throws {
        super.setUp()
        mockNetworkService = MockNetworkServiceProvider()
        service = CouponService(networkService: mockNetworkService)
    }
    
    override func tearDownWithError() throws {
        mockNetworkService = nil
        service = nil
        super.tearDown()
    }
    
    // fetchCouponList 테스트
    func test_쿠폰_목록_올바른_타겟으로_호출_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "CouponList_200_Sample")
        var capturedTarget: CouponTargets?

        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target in
                capturedTarget = target as? CouponTargets
                return (mockResponseData, mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.fetchCouponList(for: "ISSUED")
        
        // Assert
        guard let captured = capturedTarget else {
            fail("Expected CouponTargets but got \(String(describing: capturedTarget))")
            return
        }
        switch captured {
        case .fetchCouponList(let tabState):
            expect(tabState).to(equal("ISSUED"))
        default:
            fail("Expected .fetchCouponList but got \(captured)")
        }
    }
    
    func test_쿠폰_목록_RequestMethod_의존성_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "CouponList_200_Sample")
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target in
                return (mockResponseData, mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.fetchCouponList(for: "ISSUED")
        
        // Assert
        verify(mockNetworkService).request(with: any())
    }
    
    func test_쿠폰_목록_네트워크_실패_시_에러_확인() async throws {
        // Arrange
        let (mockResponseData, _) = try TestUtilities.loadMockResponse(from: "Error_400_Sample")
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
        
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).thenReturn((mockResponseData, mockURLResponse))
        }

        // Act & Assert
        await expect { try await self.service.fetchCouponList(for: "ISSUED") }.to(throwError { (error: Error) in
            if case let PolzzakError.serviceError(statusCode) = error {
                expect(statusCode).to(equal(mockURLResponse.statusCode))
            } else {
                fail("Expected PolzzakError.serviceError but got \(error)")
            }
        })
    }

    // fetchCouponDetail 테스트
    func test_쿠폰_상세_올바른_타겟으로_호출_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "CouponDetail_200_Sample")
        var capturedTarget: CouponTargets?

        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target in
                capturedTarget = target as? CouponTargets
                return (mockResponseData, mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.fetchCouponDetail(with: 1)
        
        // Assert
        guard let captured = capturedTarget else {
            fail("Expected CouponTargets but got \(String(describing: capturedTarget))")
            return
        }
        switch captured {
        case .fetchCouponDetail(let couponID):
            expect(couponID).to(equal(1))
        default:
            fail("Expected .fetchCouponDetail but got \(captured)")
        }
    }
    
    func test_쿠폰_상세_RequestMethod_의존성_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "CouponDetail_200_Sample")
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target in
                return (mockResponseData, mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.fetchCouponDetail(with: 1)
        
        // Assert
        verify(mockNetworkService).request(with: any())
    }
    
    func test_쿠폰_상세_네트워크_실패_시_에러_확인() async throws {
        // Arrange
        let (mockResponseData, _) = try TestUtilities.loadMockResponse(from: "Error_400_Sample")
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
        
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).thenReturn((mockResponseData, mockURLResponse))
        }

        // Act & Assert
        await expect { try await self.service.fetchCouponDetail(with: 1) }.to(throwError { (error: Error) in
            if case let PolzzakError.serviceError(statusCode) = error {
                expect(statusCode).to(equal(mockURLResponse.statusCode))
            } else {
                fail("Expected PolzzakError.serviceError but got \(error)")
            }
        })
    }
    

    // sendGiftRequest 테스트
    func test_선물_요청_올바른_타겟으로_호출_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "Success_201_Sample")
        var capturedTarget: CouponTargets?

        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target in
                capturedTarget = target as? CouponTargets
                return (mockResponseData, mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.sendGiftRequest(to: 1)
        
        // Assert
        guard let captured = capturedTarget else {
            fail("Expected CouponTargets but got \(String(describing: capturedTarget))")
            return
        }
        switch captured {
        case .sendGiftRequest(let couponID):
            expect(couponID).to(equal(1))
        default:
            fail("Expected .sendGiftRequest but got \(captured)")
        }
    }
    
    func test_선물_요청_RequestMethod_의존성_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "Success_201_Sample")
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target in
                return (mockResponseData, mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.sendGiftRequest(to: 1)
        
        // Assert
        verify(mockNetworkService).request(with: any())
    }
    
    func test_선물_요청_네트워크_실패_시_에러_확인() async throws {
        // Arrange
        let (mockResponseData, _) = try TestUtilities.loadMockResponse(from: "Error_400_Sample")
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
        
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).thenReturn((mockResponseData, mockURLResponse))
        }

        // Act & Assert
        await expect { try await self.service.sendGiftRequest(to: 1) }.to(throwError { (error: Error) in
            if case let PolzzakError.serviceError(statusCode) = error {
                expect(statusCode).to(equal(mockURLResponse.statusCode))
            } else {
                fail("Expected PolzzakError.serviceError but got \(error)")
            }
        })
    }

    // acceptCoupon 테스트
    func test_쿠폰_수락_올바른_타겟으로_호출_확인() async throws {
        // Arrange
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 204, httpVersion: nil, headerFields: nil)!
        var capturedTarget: CouponTargets?

        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target in
                capturedTarget = target as? CouponTargets
                return (Data(), mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.acceptCoupon(from: 1)
        
        // Assert
        guard let captured = capturedTarget else {
            fail("Expected CouponTargets but got \(String(describing: capturedTarget))")
            return
        }
        switch captured {
        case .acceptCoupon(let stampBoardID):
            expect(stampBoardID).to(equal(1))
        default:
            fail("Expected .fetchCouponList but got \(captured)")
        }
    }
    
    func test_쿠폰_수락_RequestMethod_의존성_확인() async throws {
        // Arrange
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 204, httpVersion: nil, headerFields: nil)!
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target in
                return (Data(), mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.acceptCoupon(from: 1)
        
        // Assert
        verify(mockNetworkService).request(with: any())
    }
    
    func test_쿠폰_수락_네트워크_실패_시_에러_확인() async throws {
        // Arrange
        let (mockResponseData, _) = try TestUtilities.loadMockResponse(from: "Error_400_Sample")
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
        
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).thenReturn((mockResponseData, mockURLResponse))
        }

        // Act & Assert
        await expect { try await self.service.acceptCoupon(from: 1) }.to(throwError { (error: Error) in
            if case let PolzzakError.serviceError(statusCode) = error {
                expect(statusCode).to(equal(mockURLResponse.statusCode))
            } else {
                fail("Expected PolzzakError.serviceError but got \(error)")
            }
        })
    }

    // sendGiftReceive 테스트
    func test_선물_수신_올바른_타겟으로_호출_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "Success_201_Sample")
        var capturedTarget: CouponTargets?

        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target in
                capturedTarget = target as? CouponTargets
                return (mockResponseData, mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.sendGiftReceive(from: 1)
        
        // Assert
        guard let captured = capturedTarget else {
            fail("Expected CouponTargets but got \(String(describing: capturedTarget))")
            return
        }
        switch captured {
        case .sendGiftReceive(let couponID):
            expect(couponID).to(equal(1))
        default:
            fail("Expected .sendGiftReceive but got \(captured)")
        }
    }
    
    func test_선물_수신_RequestMethod_의존성_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "Success_201_Sample")
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target in
                return (mockResponseData, mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.sendGiftReceive(from: 1)
        
        // Assert
        verify(mockNetworkService).request(with: any())
    }
    
    func test_선물_수신_네트워크_실패_시_에러_확인() async throws {
        // Arrange
        let (mockResponseData, _) = try TestUtilities.loadMockResponse(from: "Error_400_Sample")
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
        
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).thenReturn((mockResponseData, mockURLResponse))
        }

        // Act & Assert
        await expect { try await self.service.sendGiftReceive(from: 1) }.to(throwError { (error: Error) in
            if case let PolzzakError.serviceError(statusCode) = error {
                expect(statusCode).to(equal(mockURLResponse.statusCode))
            } else {
                fail("Expected PolzzakError.serviceError but got \(error)")
            }
        })
    }

}
