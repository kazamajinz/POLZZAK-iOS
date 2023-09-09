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
}
