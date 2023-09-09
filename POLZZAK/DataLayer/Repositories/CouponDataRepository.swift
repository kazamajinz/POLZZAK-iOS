//
//  CouponDataRepository.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/08.
//

import Foundation

class CouponDataRepository: CouponsRepository {
    private let couponService: CouponService
    private let couponMapper = CouponMapper()
    
    init(couponService: CouponService = CouponService()) {
        self.couponService = couponService
    }
    
    func getCouponList(_ tabState: String) async throws -> NetworkResult<BaseResponse<[CouponList]>, NetworkError> {
        let (data, response) = try await couponService.fetchCouponList(tabState)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        let statusCode = httpResponse.statusCode
        switch statusCode {
        case 200..<300:
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(BaseResponseDTO<[CouponListDTO]>.self, from: data)
            let mapData = couponMapper.mapCouponListResponse(from: decodedData)
            return .success(mapData)
        default:
            throw NetworkError.serverError(statusCode)
        }
    }
    
    func getCouponDetail(with couponID: Int) async throws -> NetworkResult<BaseResponse<CouponDetail>, NetworkError> {
        let (data, response) = try await couponService.fetchCouponDetail(couponID)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        let statusCode = httpResponse.statusCode
        switch statusCode {
        case 200..<300:
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(BaseResponseDTO<CouponDetailDTO>.self, from: data)
            let mapData = couponMapper.mapCouponDetailResponse(from: decodedData)
            return .success(mapData)
        default:
            throw NetworkError.serverError(statusCode)
        }
    }
}
