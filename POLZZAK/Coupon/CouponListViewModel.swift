//
//  CouponListViewModel.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/07/31.
//

import Combine
import UIKit

class CouponListViewModel {
    @Published var inprogressCouponListData: [CouponListData] = []
    @Published var completedCouponListData: [CouponListData] = []
    
    @Published var userType: UserType = .child
    @Published var tabState: TabState = .unknown
    @Published var inprogressFilterType: FilterType = .all
    @Published var completedFilterType: FilterType = .all
    
    init() {
        tempInprogressAPI()
    }
    
    func tempInprogressAPI() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.tabState = .inProgress
            self?.inprogressCouponListData = CouponListData.sampleData.shuffled()
        }
    }
    
    func tempCompletedAPI() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.completedCouponListData = CouponListData.sampleData.shuffled()
        }
    }
    
    func preGiftTabSelected() {
        tabState = .inProgress
    }
    
    func postGiftTabSelected() {
        tabState = .completed
        if true == completedCouponListData.isEmpty {
            tempCompletedAPI()
        }
    }
}
