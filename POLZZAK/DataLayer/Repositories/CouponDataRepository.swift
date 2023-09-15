//
//  CouponDataRepository.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/08.
//

import Foundation

class CouponDataRepository: CouponsRepository {
    private let service: CouponService
    private let couponMapper = CouponMapper()
    
    init(couponService: CouponService = CouponService()) {
        self.service = couponService
    }
    
    func getCouponList(_ tabState: String) async throws -> NetworkResult<BaseResponse<[CouponList]>, NetworkError> {
        let (data, response) = try await service.fetchCouponList(for: tabState)
        
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
        let (data, response) = try await service.fetchCouponDetail(with: couponID)
        
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
    
    func createGiftRequest(with couponID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError> {
        let (_, response) = try await service.sendGiftRequest(to: couponID)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        let statusCode = httpResponse.statusCode
        switch statusCode {
        case 204:
            return .success(nil)
        default:
            throw NetworkError.serverError(statusCode)
        }
    }
    
    func acceptCoupon(from stampBoardID: Int) async throws -> NetworkResult<BaseResponse<EmptyDataResponse>, NetworkError> {
        let (data, response) = try await service.acceptCoupon(from: stampBoardID)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        let statusCode = httpResponse.statusCode
        switch statusCode {
        case 201:
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(BaseResponseDTO<EmptyDataResponseDTO>.self, from: data)
            let mapData = couponMapper.mapEmptyDataResponse(from: decodedData)
            return .success(mapData)
        default:
            throw NetworkError.serverError(statusCode)
        }
    }
    
    func sendGiftReceive(from couponID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError> {
        let (_, response) = try await service.sendGiftReceive(from: couponID)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        let statusCode = httpResponse.statusCode
        switch statusCode {
        case 204:
            return .success(nil)
        default:
            throw NetworkError.serverError(statusCode)
        }
    }
}
