//
//  CouponTargets.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/07.
//

import Foundation

enum CouponTargets {
    case fetchCouponList(tabState: String)
    case fetchCouponDetail(couponID: Int)
}

extension CouponTargets: BasicTargetType {
    var baseURL: String {
        return Constants.URL.baseURL
    }
    
    var path: String {
        switch self {
        case .fetchCouponList:
            return "v1/coupons"
        case .fetchCouponDetail(let couponID):
            return "v1/coupons/\(couponID)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchCouponList, .fetchCouponDetail:
            return .get
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .fetchCouponList, .fetchCouponDetail:
            return nil
        }
    }
    
    var queryParameters: Encodable? {
        var query = [String: String]()
        switch self {
        case .fetchCouponList(let tabState):
            query["couponState"] = tabState
            return query
        default:
            return nil
        }
    }
    
    var bodyParameters: Encodable? {
        switch self {
        case .fetchCouponList, .fetchCouponDetail:
            return nil
        }
    }
    
    var sampleData: Data? {
        switch self {
        case .fetchCouponList, .fetchCouponDetail:
            return nil
        }
    }
}
