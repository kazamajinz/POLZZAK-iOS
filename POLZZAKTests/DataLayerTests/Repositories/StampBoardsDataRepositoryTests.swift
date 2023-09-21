//
//  StampBoardsDataRepositoryTests.swift
//  POLZZAKTests
//
//  Created by 이정환 on 2023/09/21.
//

import XCTest
import Cuckoo
import Nimble

@testable import POLZZAK

class StampBoardsDataRepositoryTests: XCTestCase {
    var sut: StampBoardsDataRepository!
    var mockService: MockStampBoardsService!
    
    override func setUp() {
        super.setUp()
        mockService = MockStampBoardsService()
        sut = StampBoardsDataRepository(stampBoardsService: mockService)
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }
    
    // getStampBoardList 테스트
    func test_getStampBoardList_서비스_호출_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "StampBoardList_200_Sample")
        
        stub(mockService) { mock in
            when(mock.fetchStampBoardList(for: any())).thenReturn((mockResponseData, mockURLResponse))
        }
        
        // Act
        _ = try await sut.getStampBoardList(for: .inProgress)
        
        // Assert
        verify(mockService).fetchStampBoardList(for: equal(to: .inProgress))
    }
    
    func test_getStampBoardList_매핑된_데이터_반환_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "StampBoardList_200_Sample")
        let expectedList = TestDataFactory.makeSampleStampBoardList()
        
        stub(mockService) { mock in
            when(mock.fetchStampBoardList(for: any())).thenReturn((mockResponseData, mockURLResponse))
        }
        
        // Act
        let result = try await sut.getStampBoardList(for: .inProgress)
        
        // Assert
        expect(result).to(equal(expectedList))
    }
    
    func test_getStampBoardList_서비스_에러_발생_확인() async throws {
        // Arrange
        let (mockResponseData, _) = try TestUtilities.loadMockResponse(from: "Error_400_Sample")
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
        
        stub(mockService) { mock in
            when(mock.fetchStampBoardList(for: any())).thenReturn((mockResponseData, mockURLResponse))
        }
        
        // Act & Assert
        await expect { try await self.sut.getStampBoardList(for: .inProgress) }.to(throwError { (thrownError: Error) in
            switch thrownError {
            case PolzzakError.repositoryError:
                break
            default:
                fail("Expected PolzzakError.repositoryError but got \(thrownError)")
            }
        })
    }
}

