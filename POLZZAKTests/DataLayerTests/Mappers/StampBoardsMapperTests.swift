//
//  StampBoardsMapperTests.swift
//  POLZZAKTests
//
//  Created by 이정환 on 2023/09/21.
//


import XCTest
import Nimble
import Cuckoo
@testable import POLZZAK

class StampBoardsMapperTests: XCTestCase {
    
    var mapper: DefaultStampBoardsMapper!
    
    override func setUp() {
        super.setUp()
        mapper = DefaultStampBoardsMapper()
    }
    
    override func tearDown() {
        mapper = nil
        super.tearDown()
    }
    
    // mapStampBoardListResponse
    func test_도장판_목록_맵핑_결과_정확성_확인() throws {
        // Arrange
        let response: BaseResponseDTO<[StampBoardListDTO]> = try TestUtilities.loadMockResponseDTO(from: "StampBoardList_200_Sample")
        // Act
        let mappedResponse = mapper.mapStampBoardListResponse(from: response)
        
        // Assert using Nimble
        if let data = mappedResponse.data?.first {
            expect(data.family.memberID).to(equal(18))
            expect(data.family.nickname).to(equal("누나"))
            expect(data.family.memberType.name).to(equal("GUARDIAN"))
            expect(data.family.memberType.detail).to(equal("누나"))
            expect(data.stampBoardSummaries.count).to(equal(1))
            expect(data.stampBoardSummaries.first?.stampBoardId).to(equal(11))
            expect(data.stampBoardSummaries.first?.status).to(equal(.issuedCoupon))
        } else {
            fail("예상했던 데이터가 존재하지 않습니다.")
        }
    }
    
    func test_도장판_상태_nil_입력시_nil_반환() {
        // Arrange
        let response: String? = nil
        
        // Act
        let mappedResponse = mapper.mapStampBoardStatus(response)
        
        // Assert
        expect(mappedResponse).to(beNil())
    }
}

