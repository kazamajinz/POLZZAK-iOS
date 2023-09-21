//
//  LinkManagementService.swift
//  POLZZAKTests
//
//  Created by 이정환 on 2023/09/20.
//

@testable import POLZZAK

import XCTest
import Nimble
import Cuckoo

class LinkManagementServiceTests: XCTestCase {
    var service: DefaultLinkManagementService!
    var mockNetworkService: MockNetworkServiceProvider!
    
    override func setUpWithError() throws {
        super.setUp()
        mockNetworkService = MockNetworkServiceProvider()
        service = DefaultLinkManagementService(networkService: mockNetworkService)
    }
    
    override func tearDownWithError() throws {
        mockNetworkService = nil
        service = nil
        super.tearDown()
    }
    
    // fetchUserByNickname 테스트
    func test_닉네임으로_유저_조회_올바른_타겟으로_호출_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "LinkManagementList_200_Sample")
        var capturedTarget: LinkManagementTargets?

        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target in
                capturedTarget = target as? LinkManagementTargets
                return (mockResponseData, mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.fetchUserByNickname("보호자")
        
        // Assert
        guard let captured = capturedTarget else {
            fail("Expected LinkManagementTargets but got \(String(describing: capturedTarget))")
            return
        }
        switch captured {
        case .searchUserByNickname(let nickname):
            expect(nickname).to(equal("보호자"))
        default:
            fail("Expected .fetchUserByNickname but got \(captured)")
        }
    }
    
    func test_닉네임으로_유저_조회_RequestMethod_의존성_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "LinkManagementList_200_Sample")
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target in
                return (mockResponseData, mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.fetchUserByNickname("보호자")
        
        // Assert
        verify(mockNetworkService).request(with: any())
    }
    
    func test_닉네임으로_유저_조회_네트워크_실패_시_에러_확인() async throws {
        // Arrange
        let (mockResponseData, _) = try TestUtilities.loadMockResponse(from: "Error_400_Sample")
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
        
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).thenReturn((mockResponseData, mockURLResponse))
        }

        // Act & Assert
        await expect { try await self.service.fetchUserByNickname("보호자") }.to(throwError { (error: Error) in
            if case let PolzzakError.serviceError(statusCode) = error {
                expect(statusCode).to(equal(mockURLResponse.statusCode))
            } else {
                fail("Expected PolzzakError.serviceError but got \(error)")
            }
        })
    }
    
    // fetchAllLinkedUsers 테스트
    func test_모든_연결된_유저_올바른_타겟으로_호출_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "LinkManagementList_200_Sample")
        var capturedTarget: LinkManagementTargets?
        
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target -> (Data, URLResponse) in
                capturedTarget = target as? LinkManagementTargets
                return (mockResponseData, mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.fetchAllLinkedUsers()
        
        // Assert
        guard let captured = capturedTarget else {
            fail("Expected LinkManagementTargets but got \(String(describing: capturedTarget))")
            return
        }
        switch captured {
        case .fetchAllLinkedUsers:
            break
        default:
            fail("Expected .fetchAllLinkedUsers but got \(captured)")
        }
    }

    func test_모든_연결된_유저_RequestMethod_의존성_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "LinkManagementList_200_Sample")
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target in
                return (mockResponseData, mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.fetchAllLinkedUsers()
        
        // Assert
        verify(mockNetworkService).request(with: any())
    }

    func test_모든_연결된_유저_네트워크_실패_시_에러_확인() async throws {
        // Arrange
        let (mockResponseData, _) = try TestUtilities.loadMockResponse(from: "Error_400_Sample")
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
        
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).thenReturn((mockResponseData, mockURLResponse))
        }
        
        // Act & Assert
        await expect { try await self.service.fetchAllLinkedUsers() }.to(throwError { (error: Error) in
            if case let PolzzakError.serviceError(statusCode) = error {
                expect(statusCode).to(equal(mockURLResponse.statusCode))
            } else {
                fail("Expected PolzzakError.serviceError but got \(error)")
            }
        })
    }
    
    // fetchAllReceivedUsers 테스트
    func test_모든_요청받은_유저_올바른_타겟으로_호출_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "LinkManagementList_200_Sample")
        var capturedTarget: LinkManagementTargets?
        
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target -> (Data, URLResponse) in
                capturedTarget = target as? LinkManagementTargets
                return (mockResponseData, mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.fetchAllReceivedUsers()
        
        // Assert
        guard let captured = capturedTarget else {
            fail("Expected LinkManagementTargets but got \(String(describing: capturedTarget))")
            return
        }
        switch captured {
        case .fetchAllReceivedLinkRequests:
            break
        default:
            fail("Expected .fetchAllReceivedLinkRequests but got \(captured)")
        }
    }

    func test_모든_요청받은_유저_RequestMethod_의존성_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "LinkManagementList_200_Sample")
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target in
                return (mockResponseData, mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.fetchAllReceivedUsers()
        
        // Assert
        verify(mockNetworkService).request(with: any())
    }

    func test_모든_요청받은_유저_네트워크_실패_시_에러_확인() async throws {
        // Arrange
        let (mockResponseData, _) = try TestUtilities.loadMockResponse(from: "Error_400_Sample")
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
        
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).thenReturn((mockResponseData, mockURLResponse))
        }
        
        // Act & Assert
        await expect { try await self.service.fetchAllReceivedUsers() }.to(throwError { (error: Error) in
            if case let PolzzakError.serviceError(statusCode) = error {
                expect(statusCode).to(equal(mockURLResponse.statusCode))
            } else {
                fail("Expected PolzzakError.serviceError but got \(error)")
            }
        })
    }
    
    // fetchAllRequestUsers 테스트
    func test_모든_요청한_유저_올바른_타겟으로_호출_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "LinkManagementList_200_Sample")
        var capturedTarget: LinkManagementTargets?
        
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target -> (Data, URLResponse) in
                capturedTarget = target as? LinkManagementTargets
                return (mockResponseData, mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.fetchAllRequestUsers()
        
        // Assert
        guard let captured = capturedTarget else {
            fail("Expected LinkManagementTargets but got \(String(describing: capturedTarget))")
            return
        }
        switch captured {
        case .fetchAllSentLinkRequests:
            break
        default:
            fail("Expected .fetchAllSentLinkRequests but got \(captured)")
        }
    }

    func test_모든_요청한_유저_RequestMethod_의존성_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "LinkManagementList_200_Sample")
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target in
                return (mockResponseData, mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.fetchAllRequestUsers()
        
        // Assert
        verify(mockNetworkService).request(with: any())
    }

    func test_모든_요청한_유저_네트워크_실패_시_에러_확인() async throws {
        // Arrange
        let (mockResponseData, _) = try TestUtilities.loadMockResponse(from: "Error_400_Sample")
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
        
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).thenReturn((mockResponseData, mockURLResponse))
        }
        
        // Act & Assert
        await expect { try await self.service.fetchAllRequestUsers() }.to(throwError { (error: Error) in
            if case let PolzzakError.serviceError(statusCode) = error {
                expect(statusCode).to(equal(mockURLResponse.statusCode))
            } else {
                fail("Expected PolzzakError.serviceError but got \(error)")
            }
        })
    }
    
    // sendLinkRequest 테스트
    func test_링크_요청_보내기_올바른_타겟으로_호출_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "Success_201_Sample")
        var capturedTarget: LinkManagementTargets?
        
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target -> (Data, URLResponse) in
                capturedTarget = target as? LinkManagementTargets
                return (mockResponseData, mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.sendLinkRequest(to: 1)
        
        // Assert
        guard let captured = capturedTarget else {
            fail("Expected LinkManagementTargets but got \(String(describing: capturedTarget))")
            return
        }
        switch captured {
        case .sendLinkRequest(let memberID):
            expect(memberID).to(equal(1))
        default:
            fail("Expected .sendLinkRequest but got \(captured)")
        }
    }
    
    func test_링크_요청_보내기_RequestMethod_의존성_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "Success_201_Sample")
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target in
                return (mockResponseData, mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.sendLinkRequest(to: 1)
        
        // Assert
        verify(mockNetworkService).request(with: any())
    }
    
    func test_링크_요청_보내기_네트워크_실패_시_에러_확인() async throws {
        // Arrange
        let (mockResponseData, _) = try TestUtilities.loadMockResponse(from: "Error_400_Sample")
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
        
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).thenReturn((mockResponseData, mockURLResponse))
        }

        // Act & Assert
        await expect { try await self.service.sendLinkRequest(to: 1) }.to(throwError { (error: Error) in
            if case let PolzzakError.serviceError(statusCode) = error {
                expect(statusCode).to(equal(mockURLResponse.statusCode))
            } else {
                fail("Expected PolzzakError.serviceError but got \(error)")
            }
        })
    }

    // cancelLinkRequest 테스트
    func test_링크_요청_취소_올바른_타겟으로_호출_확인() async throws {
        // Arrange
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 204, httpVersion: nil, headerFields: nil)!
        var capturedTarget: LinkManagementTargets?

        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target in
                capturedTarget = target as? LinkManagementTargets
                return (Data(), mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.cancelLinkRequest(to: 1)
        
        // Assert
        guard let captured = capturedTarget else {
            fail("Expected LinkManagementTargets but got \(String(describing: capturedTarget))")
            return
        }
        switch captured {
        case .cancelSentLinkRequest(let memberID):
            expect(memberID).to(equal(1))
        default:
            fail("Expected .cancelLinkRequest but got \(captured)")
        }
    }
    
    func test_링크_요청_취소_RequestMethod_의존성_확인() async throws {
        // Arrange
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 204, httpVersion: nil, headerFields: nil)!
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target in
                return (Data(), mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.cancelLinkRequest(to: 1)
        
        // Assert
        verify(mockNetworkService).request(with: any())
    }
    
    func test_링크_요청_취소_네트워크_실패_시_에러_확인() async throws {
        // Arrange
        let (mockResponseData, _) = try TestUtilities.loadMockResponse(from: "Error_400_Sample")
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
        
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).thenReturn((mockResponseData, mockURLResponse))
        }

        // Act & Assert
        await expect { try await self.service.cancelLinkRequest(to: 1) }.to(throwError { (error: Error) in
            if case let PolzzakError.serviceError(statusCode) = error {
                expect(statusCode).to(equal(mockURLResponse.statusCode))
            } else {
                fail("Expected PolzzakError.serviceError but got \(error)")
            }
        })
    }
    

    // approveLinkRequest 테스트
    func test_링크_요청_승인_올바른_타겟으로_호출_확인() async throws {
        // Arrange
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 204, httpVersion: nil, headerFields: nil)!
        var capturedTarget: LinkManagementTargets?
        
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target -> (Data, URLResponse) in
                capturedTarget = target as? LinkManagementTargets
                return (Data(), mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.approveLinkRequest(from: 1)
        
        // Assert
        guard let captured = capturedTarget else {
            fail("Expected LinkManagementTargets but got \(String(describing: capturedTarget))")
            return
        }
        switch captured {
        case .approveReceivedLinkRequest(let memberID):
            expect(memberID).to(equal(1))
        default:
            fail("Expected .approveReceivedLinkRequest but got \(captured)")
        }
    }
    
    func test_링크_요청_승인_RequestMethod_의존성_확인() async throws {
        // Arrange
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 204, httpVersion: nil, headerFields: nil)!
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target in
                return (Data(), mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.approveLinkRequest(from: 1)
        
        // Assert
        verify(mockNetworkService).request(with: any())
    }
    
    func test_링크_요청_승인_네트워크_실패_시_에러_확인() async throws {
        // Arrange
        let (mockResponseData, _) = try TestUtilities.loadMockResponse(from: "Error_400_Sample")
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
        
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).thenReturn((mockResponseData, mockURLResponse))
        }

        // Act & Assert
        await expect { try await self.service.approveLinkRequest(from: 1) }.to(throwError { (error: Error) in
            if case let PolzzakError.serviceError(statusCode) = error {
                expect(statusCode).to(equal(mockURLResponse.statusCode))
            } else {
                fail("Expected PolzzakError.serviceError but got \(error)")
            }
        })
    }

    // rejectLinkRequest 테스트
    func test_링크_요청_거절_올바른_타겟으로_호출_확인() async throws {
        // Arrange
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 204, httpVersion: nil, headerFields: nil)!
        var capturedTarget: LinkManagementTargets?

        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target in
                capturedTarget = target as? LinkManagementTargets
                return (Data(), mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.rejectLinkRequest(from: 1)
        
        // Assert
        guard let captured = capturedTarget else {
            fail("Expected LinkManagementTargets but got \(String(describing: capturedTarget))")
            return
        }
        switch captured {
        case .rejectReceivedLinkRequest(let memberID):
            expect(memberID).to(equal(1))
        default:
            fail("Expected .rejectReceivedLinkRequest but got \(captured)")
        }
    }
    
    func test_링크_요청_거절_RequestMethod_의존성_확인() async throws {
        // Arrange
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 204, httpVersion: nil, headerFields: nil)!
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target in
                return (Data(), mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.rejectLinkRequest(from: 1)
        
        // Assert
        verify(mockNetworkService).request(with: any())
    }
    
    func test_링크_요청_거절_네트워크_실패_시_에러_확인() async throws {
        // Arrange
        let (mockResponseData, _) = try TestUtilities.loadMockResponse(from: "Error_400_Sample")
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
        
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).thenReturn((mockResponseData, mockURLResponse))
        }

        // Act & Assert
        await expect { try await self.service.rejectLinkRequest(from: 1) }.to(throwError { (error: Error) in
            if case let PolzzakError.serviceError(statusCode) = error {
                expect(statusCode).to(equal(mockURLResponse.statusCode))
            } else {
                fail("Expected PolzzakError.serviceError but got \(error)")
            }
        })
    }
    
    // sendUnlinkRequest 테스트
    func test_연결_해제_요청_올바른_타겟으로_호출_확인() async throws {
        // Arrange
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 204, httpVersion: nil, headerFields: nil)!
        var capturedTarget: LinkManagementTargets?

        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target in
                capturedTarget = target as? LinkManagementTargets
                return (Data(), mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.sendUnlinkRequest(to: 1)
        
        // Assert
        guard let captured = capturedTarget else {
            fail("Expected LinkManagementTargets but got \(String(describing: capturedTarget))")
            return
        }
        switch captured {
        case .requestUnLink(let memberID):
            expect(memberID).to(equal(1))
        default:
            fail("Expected .requestUnLink but got \(captured)")
        }
    }
    
    func test_연결_해제_요청_RequestMethod_의존성_확인() async throws {
        // Arrange
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 204, httpVersion: nil, headerFields: nil)!
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target in
                return (Data(), mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.sendUnlinkRequest(to: 1)
        
        // Assert
        verify(mockNetworkService).request(with: any())
    }
    
    func test_연결_해제_요청_네트워크_실패_시_에러_확인() async throws {
        // Arrange
        let (mockResponseData, _) = try TestUtilities.loadMockResponse(from: "Error_400_Sample")
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
        
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).thenReturn((mockResponseData, mockURLResponse))
        }

        // Act & Assert
        await expect { try await self.service.sendUnlinkRequest(to: 1) }.to(throwError { (error: Error) in
            if case let PolzzakError.serviceError(statusCode) = error {
                expect(statusCode).to(equal(mockURLResponse.statusCode))
            } else {
                fail("Expected PolzzakError.serviceError but got \(error)")
            }
        })
    }
    
    // checkNewLinkRequest 테스트
    func test_새로운_링크_요청_확인_올바른_타겟으로_호출_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "New_Request_200_Sample")
        var capturedTarget: LinkManagementTargets?

        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target in
                capturedTarget = target as? LinkManagementTargets
                return (mockResponseData, mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.checkNewLinkRequest()
        
        // Assert
        guard let captured = capturedTarget else {
            fail("Expected LinkManagementTargets but got \(String(describing: capturedTarget))")
            return
        }
        switch captured {
        case .checkNewLinkRequest:
            break
        default:
            fail("Expected .checkNewLinkRequest but got \(captured)")
        }
    }
    
    func test_새로운_링크_요청_확인_RequestMethod_의존성_확인() async throws {
        // Arrange
        let (mockResponseData, mockURLResponse) = try TestUtilities.loadMockResponse(from: "New_Request_200_Sample")
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).then { target in
                return (mockResponseData, mockURLResponse)
            }
        }
        
        // Act
        _ = try await service.checkNewLinkRequest()
        
        // Assert
        verify(mockNetworkService).request(with: any())
    }
    
    func test_새로운_링크_요청_확인_네트워크_실패_시_에러_확인() async throws {
        // Arrange
        let (mockResponseData, _) = try TestUtilities.loadMockResponse(from: "Error_400_Sample")
        let mockURLResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
        
        stub(mockNetworkService) { stub in
            when(stub.request(with: any())).thenReturn((mockResponseData, mockURLResponse))
        }

        // Act & Assert
        await expect { try await self.service.checkNewLinkRequest() }.to(throwError { (error: Error) in
            if case let PolzzakError.serviceError(statusCode) = error {
                expect(statusCode).to(equal(mockURLResponse.statusCode))
            } else {
                fail("Expected PolzzakError.serviceError but got \(error)")
            }
        })
    }
}
