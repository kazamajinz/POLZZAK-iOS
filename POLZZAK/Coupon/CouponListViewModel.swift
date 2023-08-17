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
    @Published var tabState: TabState = .inProgress
    @Published var filterType: FilterType = .all
    
    var apiFinishedLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    var didEndDraggingSubject = CurrentValueSubject<Bool, Never>(false)
    
    func tempInprogressAPI(for centerLoading: Bool = false, isFirst: Bool = false) {
        showLoading(for: centerLoading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            if false == centerLoading && false == isFirst {
                self.apiFinishedLoadingSubject.send(true)
            }
            
            if isSkeleton == true {
                self.hideSkeletonView()
            } else {
                self.hideLoading(for: centerLoading)
            }
            
            self.couponListData = CouponListData.sampleData
        }
    }
    
    func tempCompletedAPI(for centerLoading: Bool = false) {
        showLoading(for: centerLoading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            if false == centerLoading {
                self.apiFinishedLoadingSubject.send(true)
            }
            self.hideLoading(for: centerLoading)
            self.couponListData = CouponListData.sampleData2
        }
    }
    
    func indexOfMember(with memberId: Int) -> Int {
        return couponListData.firstIndex { $0.family.memberId == memberId } ?? 0
    }
    
    func preGiftTabSelected() {
        if tabState != .inProgress {
            tabState = .inProgress
        }
    }
    
    func postGiftTabSelected() {
        if tabState != .completed {
            tabState = .completed
        }
    }
    
    private func hideSkeletonView() {
        isSkeleton = false
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
