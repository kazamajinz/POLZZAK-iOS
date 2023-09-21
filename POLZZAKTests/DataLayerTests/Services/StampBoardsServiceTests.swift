//
//  StampBoardsServiceTests.swift
//  POLZZAKTests
//
//  Created by 이정환 on 2023/09/20.
//


@testable import POLZZAK

import XCTest
import Nimble
import Cuckoo

class StampBoardsServiceTests: XCTestCase {
    var service: DefaultStampBoardsService!
    var mockNetworkServiceProvider: MockNetworkServiceProvider!
    
    override func setUpWithError() throws {
        super.setUp()
        mockNetworkServiceProvider = MockNetworkServiceProvider()
        service = DefaultStampBoardsService(networkService: mockNetworkServiceProvider)
    }
    
    override func tearDownWithError() throws {
        mockNetworkServiceProvider = nil
        service = nil
        super.tearDown()
    }
    
    func test_fetchStampBoardList_올바른_타겟으로_호출_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "StampBoardList_200_Sample")
        var capturedTarget: StampBoardsTargets?
        
        stub(mockNetworkServiceProvider) { stub in
            when(stub.request(with: any())).then { target -> (Data, URLResponse) in
                capturedTarget = target as? StampBoardsTargets
                return (mockResponseData, mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.fetchStampBoardList(for: .inProgress)
        
        // Assert
        guard let captured = capturedTarget else {
            fail("Expected StampBoardsTargets but got \(String(describing: capturedTarget))")
            return
        }
        switch captured {
        case .fetchStampBoardList(let tabState):
            expect(tabState).to(equal(.inProgress))
        }
    }
    
    func test_fetchStampBoardList_RequestMethod_의존성_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "StampBoardList_200_Sample")
        stub(mockNetworkServiceProvider) { stub in
            when(stub.request(with: any())).then { target in
                return (mockResponseData, mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.fetchStampBoardList(for: .inProgress)
        
        // Assert
        verify(mockNetworkServiceProvider).request(with: any())
    }
    
    func test_fetchStampBoardList_네트워크_실패_시_에러_확인() async throws {
        // Arrange
        let (mockResponseData, _) = try TestUtilities.loadMockResponse(from: "Error_400_Sample")
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
        
        stub(mockNetworkServiceProvider) { stub in
            when(stub.request(with: any())).thenReturn((mockResponseData, mockURLResponse))
        }
        
        // Act & Assert
        await expect { try await self.service.fetchStampBoardList(for: .inProgress) }.to(throwError { (thrownError: Error) in
            switch thrownError {
            case PolzzakError.serviceError:
                break
            default:
                fail("Expected PolzzakError.serviceError but got \(thrownError)")
            }
        })
    }
}

