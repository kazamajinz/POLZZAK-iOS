//
//  CouponListViewModel.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/07/31.
//

import Foundation
import Combine

final class CouponListViewModel: TabFilterLoadingViewModelProtocol {
    typealias DataListType = CouponList
    var dataList = CurrentValueSubject<[DataListType], Never>([])
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    var userType = CurrentValueSubject<UserType, Never>(.parent)
    var isSkeleton = CurrentValueSubject<Bool, Never>(true)
    var isCenterLoading = CurrentValueSubject<Bool, Never>(false)
    var tabState = CurrentValueSubject<TabState, Never>(.inProgress)
    var filterType = CurrentValueSubject<FilterType, Never>(.all)
    var apiFinishedLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    var didEndDraggingSubject = CurrentValueSubject<Bool, Never>(false)
    var shouldEndRefreshing = PassthroughSubject<Void, Never>()
    
    init() {
        setupBindings()
    }
    
    func loadData(for centerLoading: Bool = false) {
        guard false == isSkeleton.value else { return }
        switch tabState.value {
        case .inProgress:
            tempInprogressAPI(for: centerLoading)
        case .completed:
            tempCompletedAPI(for: centerLoading)
        }
    }
    
    func tempInprogressAPI(for centerLoading: Bool = false, isFirst: Bool = false) {
        showLoading(for: centerLoading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            if false == centerLoading && false == isFirst {
                self.apiFinishedLoadingSubject.send(true)
            }
            
            if isSkeleton.value == true {
                self.hideSkeletonView()
            } else {
                self.hideLoading(for: centerLoading)
            }
            
//            self.dataList.send(CouponListData.sampleData)
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
//            self.dataList.send(CouponListData.sampleData)
        }
    }
    
    func indexOfMember(with memberID: Int) -> Int {
        return dataList.value.firstIndex { $0.family.memberID == memberID } ?? 0
    }
    
    func couponID(at indexPath: IndexPath) -> Int? {
        switch filterType.value {
        case .all:
            guard false == dataList.value.isEmpty,
                  false == dataList.value[indexPath.section].coupons.isEmpty else {
                return nil
            }
            return dataList.value[indexPath.section].coupons[indexPath.row].couponID
        case .section(let memberID):
            let index = dataList.value.firstIndex { $0.family.memberID == memberID } ?? 0
            return dataList.value[index].coupons[indexPath.row].couponID
        }
    }
    
    func selectItem(at indexPath: IndexPath) -> CouponDetailViewModel? {
        guard let id = couponID(at: indexPath) else { return nil }
        return CouponDetailViewModel(tabState: tabState.value, couponID: id)
    }
    
    func isDataNotEmpty(forSection sectionIndex: Int) -> Bool {
        return false == dataList.value.isEmpty &&  false == dataList.value[sectionIndex].coupons.isEmpty
    }
}
