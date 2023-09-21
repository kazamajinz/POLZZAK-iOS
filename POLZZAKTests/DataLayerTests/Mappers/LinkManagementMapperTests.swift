//
//  LinkManagementMapperTests.swift
//  POLZZAKTests
//
//  Created by 이정환 on 2023/09/21.
//


import XCTest
import Nimble
import Cuckoo
@testable import POLZZAK

class LinkManagementMapperTests: XCTestCase {
    
    var mapper: DefaultLinkManagementMapper!
    
    override func setUp() {
        super.setUp()
        mapper = DefaultLinkManagementMapper()
    }
    
    // mapCheckLinkRequestResponse 테스트
    func test_링크_요청_확인_맵핑_결과_정확성_확인() throws {
        // Arrange
        let response: BaseResponseDTO<CheckLinkRequestDTO> = try TestUtilities.loadMockResponseDTO(from: "New_Request_200_Sample")
        
        // Act
        let mappedResponse = mapper.mapCheckLinkRequestResponse(from: response)
        
        // Assert
        if let data = mappedResponse.data {
            expect(data.isFamilyReceived).to(equal(true))
            expect(data.isFamilySent).to(equal(false))
        } else {
            fail("예상했던 데이터가 존재하지 않습니다.")
        }
    }
    
    // mapFamilyMemberResponse 테스트
    func test_가족_멤버_맵핑_결과_정확성_확인() throws {
        // Arrange
        let response: BaseResponseDTO<FamilyMemberDTO> = try TestUtilities.loadMockResponseDTO(from: "FamilyMember_200_Sample")
        
        // Act
        let mappedResponse = mapper.mapFamilyMemberResponse(from: response)
        
        // Assert
        if let data = mappedResponse.data {
            expect(data.memberID).to(equal(18))
            expect(data.nickname).to(equal("누나"))
            expect(data.memberType.name).to(equal("GUARDIAN"))
            expect(data.memberType.detail).to(equal("누나"))
        } else {
            fail("예상했던 데이터가 존재하지 않습니다.")
        }
    }
    
    // mapFamilyMemberListResponse 테스트
    func test_가족_멤버_목록_맵핑_결과_정확성_확인() throws {
        // Arrange
        let response: BaseResponseDTO<FamilyMemberListDTO> = try TestUtilities.loadMockResponseDTO(from: "LinkManagementList_200_Sample")
        
        // Act
        let mappedResponse = mapper.mapFamilyMemberListResponse(from: response)
        
        // Assert
        if let data = mappedResponse.data?.first {
            expect(data.memberID).to(equal(18))
            expect(data.nickname).to(equal("누나"))
            expect(data.memberType.name).to(equal("GUARDIAN"))
            expect(data.memberType.detail).to(equal("누나"))
        } else {
            fail("예상했던 데이터가 존재하지 않습니다.")
        }
    }
}
