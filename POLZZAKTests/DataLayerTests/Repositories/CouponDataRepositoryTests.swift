//
//  CouponDataRepositoryTests.swift
//  POLZZAKTests
//
//  Created by 이정환 on 2023/09/21.
//

import XCTest
import Cuckoo
import Nimble

@testable import POLZZAK

class CouponDataRepositoryTests: XCTestCase {
    var sut: CouponDataRepository!
    var mockService: MockCouponService!
    
    override func setUp() {
        super.setUp()
        mockService = MockCouponService()
        sut = CouponDataRepository(couponService: mockService)
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }
    
    // getCouponList 테스트
    func test_getCouponList_서비스_호출_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "CouponList_200_Sample")
        
        stub(mockService) { mock in
            when(mock.fetchCouponList(for: any())).thenReturn((mockResponseData, mockURLResponse))
        }
        
        // Act
        _ = try await sut.getCouponList("inprogress")
        
        // Assert
        verify(mockService).fetchCouponList(for: equal(to: "inprogress"))
    }
    
    func test_getCouponList_매핑된_데이터_반환_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "CouponList_200_Sample")
        let expectedList = TestDataFactory.makeSampleCouponListData()
        
        stub(mockService) { mock in
            when(mock.fetchCouponList(for: any())).thenReturn((mockResponseData, mockURLResponse))
        }
        
        // Act
        let result = try await sut.getCouponList("inprogress")
        
        // Assert
        expect(result).to(equal(expectedList))
    }
    
    func test_getCouponList_서비스_에러_발생_확인() async throws {
        // Arrange
        let (mockResponseData, _) = try TestUtilities.loadMockResponse(from: "Error_400_Sample")
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
        
        stub(mockService) { mock in
            when(mock.fetchCouponList(for: any())).thenReturn((mockResponseData, mockURLResponse))
        }
        
        // Act & Assert
        await expect { try await self.sut.getCouponList("inprogress") }.to(throwError { (thrownError: Error) in
            switch thrownError {
            case PolzzakError.repositoryError:
                break
            default:
                fail("Expected PolzzakError.repositoryError but got \(thrownError)")
            }
        })
    }
    
    // getCouponDetail 테스트
    func test_getCouponDetail_서비스_호출_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "CouponDetail_200_Sample")
        
        stub(mockService) { mock in
            when(mock.fetchCouponDetail(with: any())).thenReturn((mockResponseData, mockURLResponse))
        }
        
        // Act
        _ = try await sut.getCouponDetail(with: 1)
        
        // Assert
        verify(mockService).fetchCouponDetail(with: equal(to: 1))
    }
    
    func test_getCouponDetail_매핑된_데이터_반환_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "CouponDetail_200_Sample")
        let expectedList = TestDataFactory.makeSampleCouponDetailData()
        
        stub(mockService) { mock in
            when(mock.fetchCouponDetail(with: any())).thenReturn((mockResponseData, mockURLResponse))
        }
        
        // Act
        let result = try await sut.getCouponDetail(with: 1)
        
        // Assert
        expect(result).to(equal(expectedList))
    }
    
    func test_getCouponDetail_서비스_에러_발생_확인() async throws {
        // Arrange
        let (mockResponseData, _) = try TestUtilities.loadMockResponse(from: "Error_400_Sample")
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
        
        stub(mockService) { mock in
            when(mock.fetchCouponDetail(with: any())).thenReturn((mockResponseData, mockURLResponse))
        }
        
        // Act & Assert
        await expect { try await self.sut.getCouponDetail(with: 1) }.to(throwError { (thrownError: Error) in
            switch thrownError {
            case PolzzakError.repositoryError:
                break
            default:
                fail("Expected PolzzakError.repositoryError but got \(thrownError)")
            }
        })
    }
    
    // createGiftRequest 테스트
    func test_createGiftRequest_서비스_호출_확인() async throws {
        // Arrange
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 204, httpVersion: nil, headerFields: nil)!
        
        stub(mockService) { mock in
            when(mock.sendGiftRequest(to: any())).thenReturn((Data(), mockURLResponse))
        }

        // Act
        _ = try await sut.createGiftRequest(with: 1)

        // Assert
        verify(mockService).sendGiftRequest(to: 1)
    }
    
    // acceptCoupon 테스트
    func test_acceptCoupon_서비스_호출_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "Success_201_Sample")
        
        stub(mockService) { mock in
            when(mock.acceptCoupon(from: any())).thenReturn((mockResponseData, mockURLResponse))
        }

        // Act
        _ = try await sut.acceptCoupon(from: 1)

        // Assert
        verify(mockService).acceptCoupon(from: 1)
    }
    
    func test_acceptCoupon_매핑된_데이터_반환_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "Success_201_Sample")
        
        stub(mockService) { mock in
            when(mock.acceptCoupon(from: any())).thenReturn((mockResponseData, mockURLResponse))
        }
        
        // Act
        let result = try await sut.acceptCoupon(from: 1)
        
        // Assert
        expect(result).to(beNil())
    }
    
    func test_acceptCoupon_서비스_에러_발생_확인() async throws {
        // Arrange
        let (mockResponseData, _) = try TestUtilities.loadMockResponse(from: "Error_400_Sample")
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
        
        stub(mockService) { mock in
            when(mock.acceptCoupon(from: any())).thenReturn((mockResponseData, mockURLResponse))
        }
        
        // Act & Assert
        await expect { try await self.sut.acceptCoupon(from: 1) }.to(throwError { (thrownError: Error) in
            switch thrownError {
            case PolzzakError.repositoryError:
                break
            default:
                fail("Expected PolzzakError.repositoryError but got \(thrownError)")
            }
        })
    }
    
    // sendGiftReceive 테스트
    func test_sendGiftReceive_서비스_호출_확인() async throws {
        // Arrange
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 204, httpVersion: nil, headerFields: nil)!
        
        stub(mockService) { mock in
            when(mock.sendGiftReceive(from: any())).thenReturn((Data(), mockURLResponse))
        }

        // Act
        _ = try await sut.sendGiftReceive(from: 1)

        // Assert
        verify(mockService).sendGiftReceive(from: 1)
    }
}


