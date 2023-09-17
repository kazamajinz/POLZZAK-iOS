//
//  CouponDataRepository.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/08.
//

import Foundation

class CouponDataRepository: DataRepositoryProtocol, CouponsRepository {
    typealias MapperType = CouponMapper
    let mapper: MapperType = CouponMapper()
    
    private let service: CouponService
    
    init(couponService: CouponService = CouponService()) {
        self.service = couponService
    }
    
    func getCouponList(_ tabState: String) async throws -> NetworkResult<BaseResponse<[CouponList]>, NetworkError> {
        return try await fetchData(
            using: { try await service.fetchCouponList(for: tabState) },
            decodingTo: BaseResponseDTO<[CouponListDTO]>.self,
            map: { mapper.mapCouponListResponse(from: $0) }
        )
    }
    
    func getCouponDetail(with couponID: Int) async throws -> NetworkResult<BaseResponse<CouponDetail>, NetworkError> {
        return try await fetchData(
            using: { try await service.fetchCouponDetail(with: couponID) },
            decodingTo: BaseResponseDTO<CouponDetailDTO>.self,
            map: { mapper.mapCouponDetailResponse(from: $0) }
        )
    }
    
    func createGiftRequest(with couponID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError> {
        return try await fetchDataNoContent(
            using: { try await service.sendGiftRequest(to: couponID) }
        )
    }
    
    func acceptCoupon(from stampBoardID: Int) async throws -> NetworkResult<BaseResponse<EmptyDataResponse>, NetworkError> {
        return try await fetchData(
            using: { try await service.acceptCoupon(from: stampBoardID) },
            decodingTo: BaseResponseDTO<EmptyDataResponseDTO>.self,
            map: { mapper.mapEmptyDataResponse(from: $0) },
            handleStatusCodes: [201]
        )
    }
    
    func sendGiftReceive(from couponID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError> {
        return try await fetchDataNoContent(
            using: { try await service.sendGiftRequest(to: couponID) }
        )
    }
}
