//
//  CouponListViewModel.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/07/31.
//

import Combine
import UIKit

final class CouponListViewModel {
    @Published var isSkeleton: Bool = true
    @Published var isCenterLoading: Bool = false
    @Published var couponListData: [CouponListData] = []
    @Published var userType: UserType = .child
    @Published var tabState: TabState = .unknown
    @Published var filterType: FilterType = .unknown
    
    var apiFinishedLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    var didEndDraggingSubject = CurrentValueSubject<Bool, Never>(false)
    
    func tempInprogressAPI(for centerLoading: Bool = false) {
        showLoading(for: centerLoading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            if false == centerLoading {
                self.apiFinishedLoadingSubject.send(true)
            }
            if isSkeleton == true {
                self.hideSkeletonView()
            } else {
                self.hideLoading(for: centerLoading)
            }
            self.couponListData = CouponListData.sampleData.shuffled()
        }
    }
    
    func tempCompletedAPI(for centerLoading: Bool = false) {
        showLoading(for: centerLoading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            if false == centerLoading {
                self.apiFinishedLoadingSubject.send(true)
            }
            self.hideLoading(for: centerLoading)
            self.couponListData = []//CouponListData.sampleData.shuffled()
        }
    }
    
    func preGiftTabSelected() {
        if tabState != .unknown {
            tempInprogressAPI()
        }
        
        if tabState != .unknown {
            tabState = .inProgress
        }
    }
    
    func postGiftTabSelected() {
        if tabState == .inProgress {
            tabState = .completed
        }
    }
    
    private func hideSkeletonView() {
        if filterType == .unknown {
            self.filterType = .all
            self.tabState = .inProgress
            self.isSkeleton = false
        }
    }
    
    private func showLoading(for centerLoading: Bool) {
        if centerLoading == true {
            isCenterLoading = true
        }
    }
    
    private func hideLoading(for centerLoading: Bool) {
        if centerLoading == true {
            isCenterLoading = false
        }
    }
}
