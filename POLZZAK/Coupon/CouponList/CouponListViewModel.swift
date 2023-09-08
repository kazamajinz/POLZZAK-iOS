//
//  CouponListViewModel.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/07/31.
//

import Foundation
import Combine

final class CouponListViewModel: TabFilterLoadingViewModelProtocol {
    private let useCase: CouponsUsecase
    
    var dataList = CurrentValueSubject<[CouponList], Never>([])
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    var userType = CurrentValueSubject<UserType, Never>(.parent)
    var isSkeleton = CurrentValueSubject<Bool, Never>(true)
    var isCenterLoading = CurrentValueSubject<Bool, Never>(false)
    var tabState = CurrentValueSubject<TabState, Never>(.inProgress)
    var filterType = CurrentValueSubject<FilterType, Never>(.all)
    var apiFinishedLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    var didEndDraggingSubject = CurrentValueSubject<Bool, Never>(false)
    var shouldEndRefreshing = PassthroughSubject<Void, Never>()
    var showErrorAlertSubject = PassthroughSubject<Error, Never>()
    
    init(useCase: CouponsUsecase) {
        self.useCase = useCase
        
        setupBindings()
    }
    
    func loadData(for centerLoading: Bool = false) {
        guard false == isSkeleton.value else { return }
        fetchStampBoardListAPI(for: centerLoading)
    }
    
    func fetchStampBoardListAPI(for centerLoading: Bool = false, isFirst: Bool = false) {
        Task {
            showLoading(for: centerLoading)
            do {
                let tabState = tabStateToString(tabState.value)
                let task = useCase.fetchCouponList(tabState)
                let result = try await task.value
                hideLoading(for: centerLoading)
                dataList.send(result)
            } catch {
                handleError(error)
            }
            
            if !centerLoading && (!isFirst || self.apiFinishedLoadingSubject.value) {
                self.apiFinishedLoadingSubject.send(true)
            }
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
    
    private func tabStateToString(_ tabState: TabState) -> String {
        switch tabState {
        case .inProgress:
            return "ISSUED"
        case .completed:
            return "REWARDED"
        }
    }

    func handleError(_ error: Error) {
        if let internalError = error as? PolzzakError<Void> {
            handleInternalError(internalError)
        } else if let networkError = error as? NetworkError {
            handleNetworkError(networkError)
        } else if let decodingError = error as? DecodingError {
            handleDecodingError(decodingError)
        } else {
            handleUnknownError(error)
        }
    }
    
    private func handleInternalError(_ error: PolzzakError<Void>) {
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
