//
//  LinkManagementDataRepositoryTests.swift
//  POLZZAKTests
//
//  Created by 이정환 on 2023/09/21.
//

import XCTest
import Cuckoo
import Nimble

@testable import POLZZAK

class LinkManagementDataRepositoryTests: XCTestCase {
    var sut: LinkManagementDataRepository!
    var mockService: MockLinkManagementService!
    
    override func setUp() {
        super.setUp()
        mockService = MockLinkManagementService()
        sut = LinkManagementDataRepository(linkManagementService: mockService)
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }
    
    // getUserByNickname 테스트
    func test_getUserByNickname_서비스_호출_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "FamilyMember_200_Sample")

        stub(mockService) { mock in
            when(mock.fetchUserByNickname("누나")).thenReturn((mockResponseData, mockURLResponse))
        }

        // Act
        _ = try await sut.getUserByNickname("누나")

        // Assert
        verify(mockService).fetchUserByNickname(equal(to: "누나"))
    }
    
    func test_getUserByNickname_매핑된_데이터_반환_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "FamilyMember_200_Sample")
        let expectedList = TestDataFactory.makeSampleSerchForUserName()
        
        stub(mockService) { mock in
            when(mock.fetchUserByNickname("누나")).thenReturn((mockResponseData, mockURLResponse))
        }
        
        // Act
        let result = try await sut.getUserByNickname("누나")
        
        // Assert
        expect(result).to(equal(expectedList))
    }
    
    func test_getUserByNickname_서비스_에러_발생_확인() async throws {
        // Arrange
        let (mockResponseData, _) = try TestUtilities.loadMockResponse(from: "Error_400_Sample")
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
        
        stub(mockService) { mock in
            when(mock.fetchUserByNickname("누나")).thenReturn((mockResponseData, mockURLResponse))
        }
        
        // Act & Assert
        await expect { try await self.sut.getUserByNickname("누나") }.to(throwError { (thrownError: Error) in
            switch thrownError {
            case PolzzakError.repositoryError:
                break
            default:
                fail("Expected PolzzakError.repositoryError but got \(thrownError)")
            }
        })
    }

    // getLinkedUsers 테스트
    func test_getLinkedUsers_서비스_호출_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "LinkManagementList_200_Sample")

        stub(mockService) { mock in
            when(mock.fetchAllLinkedUsers()).thenReturn((mockResponseData, mockURLResponse))
        }

        // Act
        _ = try await sut.getLinkedUsers()

        // Assert
        verify(mockService).fetchAllLinkedUsers()
    }
    
    func test_getLinkedUsers_매핑된_데이터_반환_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "LinkManagementList_200_Sample")
        let expectedList = TestDataFactory.makeSampleLinkMagementList()
        
        stub(mockService) { mock in
            when(mock.fetchAllLinkedUsers()).thenReturn((mockResponseData, mockURLResponse))
        }
        
        // Act
        let result = try await sut.getLinkedUsers()
        
        // Assert
        expect(result).to(equal(expectedList))
    }
    
    func test_getLinkedUsers_서비스_에러_발생_확인() async throws {
        // Arrange
        let (mockResponseData, _) = try TestUtilities.loadMockResponse(from: "Error_400_Sample")
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
        
        stub(mockService) { mock in
            when(mock.fetchAllLinkedUsers()).thenReturn((mockResponseData, mockURLResponse))
        }
        
        // Act & Assert
        await expect { try await self.sut.getLinkedUsers() }.to(throwError { (thrownError: Error) in
            switch thrownError {
            case PolzzakError.repositoryError:
                break
            default:
                fail("Expected PolzzakError.repositoryError but got \(thrownError)")
            }
        })
    }

    // getReceivedLinkRequests 테스트
    func test_getReceivedLinkRequests_서비스_호출_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "LinkManagementList_200_Sample")

        stub(mockService) { mock in
            when(mock.fetchAllReceivedUsers()).thenReturn((mockResponseData, mockURLResponse))
        }

        // Act
        _ = try await sut.getReceivedLinkRequests()

        // Assert
        verify(mockService).fetchAllReceivedUsers()
    }
    
    func test_getReceivedLinkRequests_매핑된_데이터_반환_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "LinkManagementList_200_Sample")
        let expectedList = TestDataFactory.makeSampleLinkMagementList()
        
        stub(mockService) { mock in
            when(mock.fetchAllReceivedUsers()).thenReturn((mockResponseData, mockURLResponse))
        }
        
        // Act
        let result = try await sut.getReceivedLinkRequests()
        
        // Assert
        expect(result).to(equal(expectedList))
    }
    
    func test_getReceivedLinkRequests_서비스_에러_발생_확인() async throws {
        // Arrange
        let (mockResponseData, _) = try TestUtilities.loadMockResponse(from: "Error_400_Sample")
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
        
        stub(mockService) { mock in
            when(mock.fetchAllReceivedUsers()).thenReturn((mockResponseData, mockURLResponse))
        }
        
        // Act & Assert
        await expect { try await self.sut.getReceivedLinkRequests() }.to(throwError { (thrownError: Error) in
            switch thrownError {
            case PolzzakError.repositoryError:
                break
            default:
                fail("Expected PolzzakError.repositoryError but got \(thrownError)")
            }
        })
    }


    // getSentLinkRequests 테스트
    func test_getSentLinkRequests_서비스_호출_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "LinkManagementList_200_Sample")

        stub(mockService) { mock in
            when(mock.fetchAllRequestUsers()).thenReturn((mockResponseData, mockURLResponse))
        }

        // Act
        _ = try await sut.getSentLinkRequests()

        // Assert
        verify(mockService).fetchAllRequestUsers()
    }
    
    func test_getSentLinkRequests_매핑된_데이터_반환_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "LinkManagementList_200_Sample")
        let expectedList = TestDataFactory.makeSampleLinkMagementList()
        
        stub(mockService) { mock in
            when(mock.fetchAllRequestUsers()).thenReturn((mockResponseData, mockURLResponse))
        }
        
        // Act
        let result = try await sut.getSentLinkRequests()
        
        // Assert
        expect(result).to(equal(expectedList))
    }
    
    func test_getSentLinkRequests_서비스_에러_발생_확인() async throws {
        // Arrange
        let (mockResponseData, _) = try TestUtilities.loadMockResponse(from: "Error_400_Sample")
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
        
        stub(mockService) { mock in
            when(mock.fetchAllRequestUsers()).thenReturn((mockResponseData, mockURLResponse))
        }
        
        // Act & Assert
        await expect { try await self.sut.getSentLinkRequests() }.to(throwError { (thrownError: Error) in
            switch thrownError {
            case PolzzakError.repositoryError:
                break
            default:
                fail("Expected PolzzakError.repositoryError but got \(thrownError)")
            }
        })
    }

    // createLinkRequest 테스트
    func test_createLinkRequest_서비스_호출_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "Success_201_Sample")
        
        stub(mockService) { mock in
            when(mock.sendLinkRequest(to: any())).thenReturn((mockResponseData, mockURLResponse))
        }

        // Act
        _ = try await sut.createLinkRequest(to: 1)

        // Assert
        verify(mockService).sendLinkRequest(to: 1)
    }
    
    func test_createLinkRequest_매핑된_데이터_반환_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "Success_201_Sample")
        
        stub(mockService) { mock in
            when(mock.sendLinkRequest(to: any())).thenReturn((mockResponseData, mockURLResponse))
        }
        
        // Act
        let result = try await sut.createLinkRequest(to: 1)
        
        // Assert
        expect(result).to(beNil())
    }
    
    func test_createLinkRequest_서비스_에러_발생_확인() async throws {
        // Arrange
        let (mockResponseData, _) = try TestUtilities.loadMockResponse(from: "Error_400_Sample")
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
        
        stub(mockService) { mock in
            when(mock.sendLinkRequest(to: any())).thenReturn((mockResponseData, mockURLResponse))
        }
        
        // Act & Assert
        await expect { try await self.sut.createLinkRequest(to: 1) }.to(throwError { (thrownError: Error) in
            switch thrownError {
            case PolzzakError.repositoryError:
                break
            default:
                fail("Expected PolzzakError.repositoryError but got \(thrownError)")
            }
        })
    }

    // deleteSentLinkRequest 테스트
    func test_deleteSentLinkRequest_서비스_호출_확인() async throws {
        // Arrange
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 204, httpVersion: nil, headerFields: nil)!
        
        stub(mockService) { mock in
            when(mock.cancelLinkRequest(to: any())).thenReturn((Data(), mockURLResponse))
        }

        // Act
        _ = try await sut.deleteSentLinkRequest(to: 1)

        // Assert
        verify(mockService).cancelLinkRequest(to: 1)
    }

    // removeLink 테스트
    func test_removeLink_서비스_호출_확인() async throws {
        // Arrange
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 204, httpVersion: nil, headerFields: nil)!
        
        stub(mockService) { mock in
            when(mock.sendUnlinkRequest(to: any())).thenReturn((Data(), mockURLResponse))
        }

        // Act
        _ = try await sut.removeLink(with: 1)

        // Assert
        verify(mockService).sendUnlinkRequest(to: 1)
    }

    // checkNewLinkRequest 테스트
    func test_checkNewLinkRequest_서비스_호출_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "New_Request_200_Sample")

        stub(mockService) { mock in
            when(mock.checkNewLinkRequest()).thenReturn((mockResponseData, mockURLResponse))
        }

        // Act
        _ = try await sut.checkNewLinkRequest()

        // Assert
        verify(mockService).checkNewLinkRequest()
    }
    
    func test_checkNewLinkRequest_매핑된_데이터_반환_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "New_Request_200_Sample")
        let expectedList = TestDataFactory.makeSampleNewRequestData()
        
        stub(mockService) { mock in
            when(mock.checkNewLinkRequest()).thenReturn((mockResponseData, mockURLResponse))
        }
        
        // Act
        let result = try await sut.checkNewLinkRequest()
        
        // Assert
        expect(result).to(equal(expectedList))
    }
    
    func test_checkNewLinkRequest_서비스_에러_발생_확인() async throws {
        // Arrange
        let (mockResponseData, _) = try TestUtilities.loadMockResponse(from: "Error_400_Sample")
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
        
        stub(mockService) { mock in
            when(mock.checkNewLinkRequest()).thenReturn((mockResponseData, mockURLResponse))
        }
        
        // Act & Assert
        await expect { try await self.sut.checkNewLinkRequest() }.to(throwError { (thrownError: Error) in
            switch thrownError {
            case PolzzakError.repositoryError:
                break
            default:
                fail("Expected PolzzakError.repositoryError but got \(thrownError)")
            }
        })
    }
}
