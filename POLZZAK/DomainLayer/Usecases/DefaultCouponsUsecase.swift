//
//  DefaultCouponsUsecase.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/09.
//

import Foundation

protocol CouponsUsecase {
    func fetchCouponList(_ tabState: String) -> Task<[CouponList], Error>
    func fetchCouponDetail(with couponID: Int) -> Task<CouponDetail, Error>
}

class DefaultCouponsUseCase: CouponsUsecase {
    let repository: CouponsRepository
    
    init(repository: CouponsRepository) {
        self.repository = repository
    }
    
    func fetchCouponList(_ tabState: String) -> Task<[CouponList], Error> {
        return Task {
            do {
                let result = try await repository.getCouponList(tabState)
                switch result {
                case .success(let response):
                    return response?.data ?? []
                case .failure(let error):
                    throw error
                }
            } catch {
                throw error
            }
        }
    }
    
    func fetchCouponDetail(with couponID: Int) -> Task<CouponDetail, Error> {
        return Task {
            do {
                let result = try await repository.getCouponDetail(with: couponID)
                switch result {
                case .success(let response):
                    guard let response, let data = response.data else {
                        throw NetworkError.emptyReponse
                    }
                    return data
                case .failure(let error):
                    throw error
                }
            } catch {
                throw error
            }
        }
    }
}
