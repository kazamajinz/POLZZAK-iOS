//
//  CouponService.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/07.
//

import Foundation

class CouponService {
    private let networkService: NetworkServiceProvider
    
    init(networkService: NetworkServiceProvider = NetworkService(requestInterceptor: TokenInterceptor())) {
        self.networkService = networkService
    }
    
    func fetchCouponList(for tabState: String) async throws -> (Data, URLResponse) {
        return try await networkService.request(with: CouponTargets.fetchCouponList(tabState: tabState))
    }
    
    func fetchCouponDetail(with couponID: Int) async throws -> (Data, URLResponse) {
        return try await networkService.request(with: CouponTargets.fetchCouponDetail(couponID: couponID))
    }
    
    func sendGiftRequest(to couponID: Int) async throws -> (Data, URLResponse) {
        return try await networkService.request(with: CouponTargets.sendGiftRequest(couponID: couponID))
    }
    
    func acceptCoupon(from stampBoardID: Int) async throws -> (Data, URLResponse) {
        return try await networkService.request(with: CouponTargets.acceptCoupon(stampBoardID: stampBoardID))
    }
    
    func sendGiftReceive(from couponID: Int) async throws -> (Data, URLResponse) {
        return try await networkService.request(with: CouponTargets.sendGiftReceive(couponID: couponID))
    }
}
