//
//  MainViewModel.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/23.
//

import Foundation
import Combine

final class StampBoardViewModel: TabFilterLoadingViewModelProtocol {
    private let useCase: StampBoardsUseCase
    
    var dataList = CurrentValueSubject<[StampBoardList], Never>([])
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    var userType: UserType
    var isSkeleton = CurrentValueSubject<Bool, Never>(true)
    var isCenterLoading = CurrentValueSubject<Bool, Never>(false)
    var tabState = CurrentValueSubject<TabState, Never>(.inProgress)
    var filterType = CurrentValueSubject<FilterType, Never>(.all)
    var apiFinishedLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    var didEndDraggingSubject = CurrentValueSubject<Bool, Never>(false)
    var shouldEndRefreshing = PassthroughSubject<Void, Never>()
    var showErrorAlertSubject = PassthroughSubject<Error, Never>()
    
    init(useCase: StampBoardsUseCase) {
        self.useCase = useCase
        
        //TODO: - DTO에서 Model로 변환할때 UserType을 단순하게 부모인지 아이인지 변환하고 UserInfo에서 사용하는 Model에 userType을 추가했으면 좋겠음.
        let userInfo = UserInfoManager.readUserInfo()
        userType = (userInfo?.memberType.detail == "아이" ? .child : .parent)
        
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
                let task = useCase.fetchStampBoardList(for: tabState)
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
    
    func isDataNotEmpty(forSection sectionIndex: Int) -> Bool {
        return false == dataList.value.isEmpty &&  false == dataList.value[sectionIndex].stampBoardSummaries.isEmpty
    }
    
    private func tabStateToString(_ tabState: TabState) -> String {
        switch tabState {
        case .inProgress:
            return "in_progress"
        case .completed:
            return "ended"
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
