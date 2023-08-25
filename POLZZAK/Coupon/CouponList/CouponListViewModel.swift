//
//  CouponListViewModel.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/07/31.
//

import Combine
import UIKit

final class CouponListViewModel {
    //TODO: - 임시
    @Published var userType: UserType = .child
    
    @Published var isSkeleton: Bool = true
    @Published var isCenterLoading: Bool = false
    @Published var couponListData: [CouponListData] = []
    @Published var tabState: TabState = .inProgress
    @Published var filterType: FilterType = .all
    @Published var apiFinishedLoadingSubject: Bool = false
    @Published var didEndDraggingSubject: Bool = false
    
    func tempInprogressAPI(for centerLoading: Bool = false, isFirst: Bool = false) {
        showLoading(for: centerLoading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            if false == centerLoading && false == isFirst {
                self.apiFinishedLoadingSubject = true
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
                self.apiFinishedLoadingSubject = true
            }
            self.hideLoading(for: centerLoading)
            self.couponListData = CouponListData.sampleData3
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
    
    func resetSubjects() {
        self.apiFinishedLoadingSubject = false
        self.didEndDraggingSubject = false
    }
    
    func refreshData() {
        switch tabState {
        case .inProgress:
            tempInprogressAPI()
        case .completed:
            tempCompletedAPI()
        }
    }
    
    func couponID(at indexPath: IndexPath) -> Int? {
        switch filterType {
        case .all:
            guard false == couponListData.isEmpty,
                  false == couponListData[indexPath.section].coupons.isEmpty else {
                return nil
            }
            return couponListData[indexPath.section].coupons[indexPath.row].couponID
        case .section(let memberId):
            let index = couponListData.firstIndex { $0.family.memberId == memberId } ?? 0
            return couponListData[index].coupons[indexPath.row].couponID
        }
    }
    
    func selectItem(at indexPath: IndexPath) -> CouponDetailViewModel? {
        guard let id = couponID(at: indexPath) else { return nil }
        return CouponDetailViewModel(tabState: self.tabState, couponID: id)
    }
}
