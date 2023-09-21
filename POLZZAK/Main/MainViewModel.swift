//
//  MainViewModel.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/23.
//

import Foundation
import Combine

final class StampBoardViewModel: TabFilterViewModelProtocol, PullToRefreshProtocol, LoadingViewModelProtocol, ErrorHandlingProtocol {
    private let repository: StampBoardsDataRepository
    
    var dataList = CurrentValueSubject<[StampBoardList], Never>([])
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    var userType: UserType
    var isSkeleton = CurrentValueSubject<Bool, Never>(true)
    var isCenterLoading = CurrentValueSubject<Bool, Never>(false)
    var tabState = CurrentValueSubject<TabState, Never>(.inProgress)
    var filterType = CurrentValueSubject<FilterType, Never>(.all)
    var apiFinishedLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    var didEndDraggingSubject = PassthroughSubject<Void, Never>()
    var shouldEndRefreshing = PassthroughSubject<Bool, Never>()
    var showErrorAlertSubject = PassthroughSubject<Error, Never>()
    
    init(repository: StampBoardsDataRepository) {
        self.repository = repository
        
        //TODO: - DTO에서 Model로 변환할때 UserType을 단순하게 부모인지 아이인지 변환하고 UserInfo에서 사용하는 Model에 userType을 추가했으면 좋겠음.
        let userInfo = UserInfoManager.readUserInfo()
        userType = (userInfo?.memberType.detail == "아이" ? .child : .parent)
        
        setupPullToRefreshBinding()
        setupTabFilterBindings()
    }
    
    func loadData(for centerLoading: Bool = false) {
        guard false == isSkeleton.value else { return }
        fetchStampBoardListAPI(for: centerLoading)
    }
    
    func fetchStampBoardListAPI(for centerLoading: Bool = false, isFirst: Bool = false) {
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
                let result = try await repository.getStampBoardList(for: tabState.value)
                dataList.send(result)
            } catch {
                handleError(error)
            }
        }
    }
    
    func sectionOfMember(with memberID: Int) -> Int? {
        return dataList.value.firstIndex { $0.family.memberID == memberID } ?? 0
    }
    
    func isDataNotEmpty(forSection sectionIndex: Int) -> Bool {
        return false == dataList.value.isEmpty &&  false == dataList.value[sectionIndex].stampBoardSummaries.isEmpty
    }
}
