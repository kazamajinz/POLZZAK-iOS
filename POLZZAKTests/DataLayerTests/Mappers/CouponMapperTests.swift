//
//  CouponMapperTests.swift
//  POLZZAKTests
//
//  Created by 이정환 on 2023/09/21.
//


import XCTest
import Nimble
@testable import POLZZAK

class CouponMapperTests: XCTestCase {
    
    var mapper: DefaultCouponMapper!
    
    override func setUp() {
        super.setUp()
        mapper = DefaultCouponMapper()
    }
    
    override func tearDown() {
        mapper = nil
        super.tearDown()
    }
    
    // mapCouponListResponse 테스트
    func test_쿠폰_목록_맵핑_결과_정확성_확인() throws {
        // Arrange
        let response: BaseResponseDTO<[CouponListDTO]> = try TestUtilities.loadMockResponseDTO(from: "CouponList_200_Sample")
        
        // Act
        let mappedResponse = mapper.mapCouponListResponse(from: response)
        
        // Assert
        if let data = mappedResponse.data?.first, let couponData = data.coupons.first {
            expect(couponData.couponID).to(equal(5))
            expect(couponData.reward).to(equal("123"))
            expect(couponData.rewardRequestDate).to(beNil())
            expect(couponData.rewardDate).to(equal("2023-09-17T08:17:50"))
        } else {
            fail("예상했던 데이터가 존재하지 않습니다.")
        }
    }
    
    // mapCouponDetailResponse 테스트
    func test_쿠폰_상세_맵핑_결과_정확성_확인() throws {
        // Arrange
        let response: BaseResponseDTO<CouponDetailDTO> = try TestUtilities.loadMockResponseDTO(from: "CouponDetail_200_Sample")
        
        // Act
        let mappedResponse = mapper.mapCouponDetailResponse(from: response)
        
        if let data = mappedResponse.data {
            expect(data.couponID).to(equal(15))
            expect(data.reward).to(equal("안녕"))
            expect(data.guardian.nickname).to(equal("보호자"))
            expect(data.stampCount).to(equal(10))
            expect(data.couponState).to(equal(.rewarded))
            expect(data.missionContents).to(beEmpty())
        } else {
            fail("예상했던 데이터가 존재하지 않습니다.")
        }
    }
}

