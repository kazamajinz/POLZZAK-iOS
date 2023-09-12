//
//  CouponsRepository.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/08.
//

import Foundation

protocol CouponsRepository {
    func getCouponList(_ tabState: String) async throws -> NetworkResult<BaseResponse<[CouponList]>, NetworkError>
    func getCouponDetail(with couponID: Int) async throws -> NetworkResult<BaseResponse<CouponDetail>, NetworkError>
    func createGiftRequest(with couponID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
    func acceptCoupon(from stampBoardID: Int) async throws -> NetworkResult<BaseResponse<EmptyDataResponse>, NetworkError>
    func sendGiftReceive(from couponID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
}
