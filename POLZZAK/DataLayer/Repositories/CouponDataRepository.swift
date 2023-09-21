//
//  CouponDataRepository.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/08.
//

import Foundation

protocol CouponRepository {
    func getCouponList(_ tabState: String) async throws -> [CouponList]
    func getCouponDetail(with couponID: Int) async throws -> CouponDetail?
    func createGiftRequest(with couponID: Int) async throws
    func acceptCoupon(from stampBoardID: Int) async throws -> EmptyDataResponse?
    func sendGiftReceive(from couponID: Int) async throws
}

final class CouponDataRepository: DataRepositoryProtocol, CouponRepository {
    typealias MapperType = DefaultCouponMapper
    let mapper: MapperType = DefaultCouponMapper()
    
    private let service: CouponService
    
    init(couponService: CouponService = CouponService()) {
        self.service = couponService
    }
    
    func getCouponList(_ tabState: String) async throws -> [CouponList] {
        let response: BaseResponse<[CouponList]> = try await fetchData(
            using: { try await service.fetchCouponList(for: tabState) },
            decodingTo: BaseResponseDTO<[CouponListDTO]>.self,
            map: mapper.mapCouponListResponse
        )
        return response.data ?? []
    }
    
    func getCouponDetail(with couponID: Int) async throws -> CouponDetail? {
        let response: BaseResponse<CouponDetail> = try await fetchData(
            using: { try await service.fetchCouponDetail(with: couponID) },
            decodingTo: BaseResponseDTO<CouponDetailDTO>.self,
            map: mapper.mapCouponDetailResponse
        )
        return response.data
    }
    
    func createGiftRequest(with couponID: Int) async throws {
        let (_, reponse) = try await service.sendGiftRequest(to: couponID)
        try fetchDataNoContent(response: reponse)
    }
    
//TODO: - 수정할것
    func acceptCoupon(from stampBoardID: Int) async throws -> EmptyDataResponse? {
        let response: BaseResponse<EmptyDataResponse> = try await fetchData(
            using: { try await service.acceptCoupon(from: stampBoardID) },
            decodingTo: BaseResponseDTO<EmptyDataResponseDTO>.self,
            map: mapper.mapEmptyDataResponse
        )
        return response.data
    }
    
    func sendGiftReceive(from couponID: Int) async throws {
        let (_, reponse) = try await service.sendGiftReceive(from: couponID)
        try fetchDataNoContent(response: reponse)
    }

}
