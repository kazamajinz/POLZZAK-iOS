//
//  CouponListViewModel.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/07/31.
//

import Foundation
import Combine

final class CouponListViewModel: TabFilterViewModelProtocol, PullToRefreshProtocol, LoadingViewModelProtocol {
    private let repository: CouponRepository
    
    var dataList = CurrentValueSubject<[CouponList], Never>([])
    var cancellables = Set<AnyCancellable>()
    
    var userType: UserType
    var isSkeleton = CurrentValueSubject<Bool, Never>(true)
    var isCenterLoading = CurrentValueSubject<Bool, Never>(false)
    var tabState = CurrentValueSubject<TabState, Never>(.inProgress)
    var filterType = CurrentValueSubject<FilterType, Never>(.all)
    var apiFinishedLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    var didEndDraggingSubject = PassthroughSubject<Void, Never>()
    var shouldEndRefreshing = PassthroughSubject<Bool, Never>()
    var requestGiftSubject = PassthroughSubject<Void, Never>()
    var receiveGiftSubject = PassthroughSubject<Void, Never>()
    var dataChanged = CurrentValueSubject<IndexPath?, Never>(nil)
    var dataDeleted = CurrentValueSubject<IndexPath?, Never>(nil)
    var showErrorAlertSubject = PassthroughSubject<Error, Never>()
    
    init(repository: CouponRepository) {
        self.repository = repository
        
        //TODO: - DTO에서 Model로 변환할때 UserType을 단순하게 부모인지 아이인지 변환하고 UserInfo에서 사용하는 Model에 userType을 추가했으면 좋겠음.
        let userInfo = UserInfoManager.readUserInfo()
        userType = (userInfo?.memberType.detail == "아이" ? .child : .parent)
        
        setupPullToRefreshBinding()
        setupTabFilterBindings()
    }
    
    func loadData(for centerLoading: Bool = false) {
        guard false == isSkeleton.value else { return }
        fetchCouponListAPI(for: centerLoading)
    }
    
    func fetchCouponListAPI(for centerLoading: Bool = false, isFirst: Bool = false) {
        Task {
            defer {
                hideLoading(for: centerLoading)
                apiFinishedLoadingSubject.send(true)
            }
            
            if true == isCenterLoading.value {
                return
            }
            
            showLoading(for: centerLoading)
            
            if true == isFirst {
                self.shouldEndRefreshing.send(true)
            }
            
            do {
                let tabState = tabStateToString(tabState.value)
                let result = try await repository.getCouponList(tabState)
                dataList.send(result)
            } catch {
                handleError(error)
            }
        }
    }
    
    func sectionOfMember(with memberID: Int) -> Int? {
        return dataList.value.firstIndex { $0.family.memberID == memberID }
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
            guard let section = sectionOfMember(with: memberID),
                  false == dataList.value[section].coupons.isEmpty else {
                return nil
            }
            return dataList.value[section].coupons[indexPath.row].couponID
        case .none:
            return nil
        }
    }
    
    func selectItem(at indexPath: IndexPath) -> CouponDetailViewModel? {
        guard let id = couponID(at: indexPath) else { return nil }
        return CouponDetailViewModel(repository: repository, couponID: id)
    }
    
    func isDataNotEmpty(forSection sectionIndex: Int) -> Bool {
        return false == dataList.value.isEmpty &&  false == dataList.value[sectionIndex].coupons.isEmpty
    }
    
    private func tabStateToString(_ tabState: TabState) -> String {
        switch tabState {
        case .inProgress:
            return "ISSUED"
        case .completed:
            return "REWARDED"
        }
    }
    
    func sendGiftRequest(indexPath: IndexPath) async -> Bool {
        do {
            guard let couponID = couponID(at: indexPath) else {
                return false
            }
            try await repository.createGiftRequest(with: couponID)
            startTimer(indexPath: indexPath)
            return true
        } catch {
            handleError(error)
            return false
        }
    }
    
    func sendGiftReceive(indexPath: IndexPath) async {
        do {
            guard let couponID = couponID(at: indexPath) else { return }
            try await repository.sendGiftReceive(from: couponID)
            removeData(indexPath: indexPath)
        } catch {
            handleError(error)
        }
    }
    
    func startTimer(indexPath: IndexPath) {
        guard let convertIndexPath = convertIndexPath(indexPath) else {
            return
        }
        
        var tempDataList = dataList.value
        
        let family = tempDataList[convertIndexPath.section].family
        var coupons = tempDataList[convertIndexPath.section].coupons
        let coupon = coupons[convertIndexPath.row]
        let convertCoupon = Coupon(
            couponID: coupon.couponID,
            reward: coupon.reward,
            rewardRequestDate: Date().toString(),
            rewardDate: coupon.rewardDate
        )
        coupons[convertIndexPath.row] = convertCoupon
        
        let updatedCouponList = CouponList(family: family, coupons: coupons)
        tempDataList[convertIndexPath.section] = updatedCouponList
        
        dataList.send(tempDataList)
        dataChanged.send(convertIndexPath)
    }
    
    func removeData(indexPath: IndexPath) {
        guard let convertIndexPath = convertIndexPath(indexPath) else {
            return
        }
        
        var tempDataList = dataList.value
        
        let family = tempDataList[convertIndexPath.section].family
        var coupons = tempDataList[convertIndexPath.section].coupons
        coupons.remove(at: convertIndexPath.row)
        
        let updatedCouponList = CouponList(family: family, coupons: coupons)
        tempDataList[convertIndexPath.section] = updatedCouponList
        
        dataList.send(tempDataList)
        dataDeleted.send(convertIndexPath)
    }
    
    func convertIndexPath(_ indexPath: IndexPath) -> IndexPath? {
        switch filterType.value {
        case .all:
            return indexPath
        case .section(let memberID):
            guard let section = sectionOfMember(with: memberID) else { return nil }
            return IndexPath(row: indexPath.row, section: section)
        case .none:
            return nil
        }
    }
    
    func handleError(_ error: Error) {
        if let internalError = error as? PolzzakError {
            handleInternalError(internalError)
        } else if let networkError = error as? NetworkError {
            handleNetworkError(networkError)
        } else if let decodingError = error as? DecodingError {
            handleDecodingError(decodingError)
        } else {
            handleUnknownError(error)
        }
    }
    
    private func handleInternalError(_ error: PolzzakError) {
        showErrorAlertSubject.send(error)
    }
    
    private func handleNetworkError(_ error: NetworkError) {
        showErrorAlertSubject.send(error)
    }
    
    private func handleDecodingError(_ error: DecodingError) {
        showErrorAlertSubject.send(error)
    }
    
    private func handleUnknownError(_ error: Error) {
        showErrorAlertSubject.send(error)
    }
}
