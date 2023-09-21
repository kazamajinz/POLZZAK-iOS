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
    case sendGiftRequest(couponID: Int)
    case acceptCoupon(stampBoardID: Int)
    case sendGiftReceive(couponID: Int)
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
        case .sendGiftRequest(let couponID):
            return "v1/coupons/\(couponID)/request"
        case .acceptCoupon:
            return "v1/coupons"
        case .sendGiftReceive(let couponID):
            return "v1/coupons/\(couponID)/receive"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchCouponList, .fetchCouponDetail:
            return .get
        case .sendGiftRequest, .acceptCoupon, .sendGiftReceive:
            return .post
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .acceptCoupon:
            return ["Content-Type": "application/json"]
        default:
            return nil
        }
    }
    
    var queryParameters: Encodable? {
        var query = [String : String]()
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
        case .acceptCoupon(let stampBoardID):
            return ["stampBoardId" : stampBoardID]
        default:
            return nil
        }
    }
    
    var sampleData: Data? {
        switch self {
        default:
            return nil
        }
    }
}
