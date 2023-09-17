//
//  DefaultCouponsUseCase.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/09.
//

import Foundation

protocol CouponsUseCase {
    func fetchCouponList(for tabState: String) -> Task<[CouponList], Error>
    func fetchCouponDetail(with couponID: Int) -> Task<CouponDetail, Error>
    func sendGiftRequest(to couponID: Int) -> Task<Void, Error>
    func acceptCoupon(from stampBoardID: Int) -> Task<Void, Error>
    func sendGiftReceive(from couponID: Int) -> Task<Void, Error>
    
}

class DefaultCouponsUseCase: UseCaseProtocol, CouponsUseCase {
    let repository: CouponsRepository
    
    init(repository: CouponsRepository) {
        self.repository = repository
    }
    
    func fetchCouponList(for tabState: String) -> Task<[CouponList], Error> {
        return Task {
            let result = try await repository.getCouponList(tabState)
            return try processResult(result) ?? []
        }
    }
    
    func fetchCouponDetail(with couponID: Int) -> Task<CouponDetail, Error> {
        return Task {
            let result = try await repository.getCouponDetail(with: couponID)
            guard let responseData = try processResult(result) else {
                throw NetworkError.emptyReponse
            }
            return responseData
        }
    }
    
    func sendGiftRequest(to couponID: Int) -> Task<Void, Error> {
        return Task {
            let result = try await repository.createGiftRequest(with: couponID)
            _ = try processResult(result)
        }
    }
    
    func acceptCoupon(from stampBoardID: Int) -> Task<Void, Error> {
        return Task {
            let result = try await repository.acceptCoupon(from: stampBoardID)
            _ = try processResult(result)
        }
    }
    
    func sendGiftReceive(from couponID: Int) -> Task<Void, Error> {
        return Task {
            let result = try await repository.sendGiftReceive(from: couponID)
            _ = try processResult(result)
        }
    }
}
