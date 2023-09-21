//
//  NotificationViewModel.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/07/11.
//

import Foundation
import Combine

final class NotificationViewModel: PullToRefreshProtocol, LoadingViewModelProtocol {
    private let repository: NotificationDataRepository
    
    @Published var saveStartID: Int? = nil
    @Published var notificationList: [NotificationData] = []
    var cancellables = Set<AnyCancellable>()
    
    var isSkeleton = CurrentValueSubject<Bool, Never>(true)
    var isCenterLoading = CurrentValueSubject<Bool, Never>(false)
    var apiFinishedLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    var didEndDraggingSubject = PassthroughSubject<Void, Never>()
    var shouldEndRefreshing = PassthroughSubject<Bool, Never>()
    var rechedBottomSubject = CurrentValueSubject<Bool, Never>(false)
    var showErrorAlertSubject = PassthroughSubject<Error, Never>()
    
    init(repository: NotificationDataRepository) {
        self.repository = repository
        
        setupPullToRefreshBinding()
        setupBottomRefreshBindings()
    }
    
    private func setupBottomRefreshBindings() {
        rechedBottomSubject.combineLatest(didEndDraggingSubject)
            .map { rechedBottom, _ -> Bool in
                return rechedBottom
            }
            .filter { $0 }
            .filter { [weak self] _ in
                return false == self?.isCenterLoading.value
            }
            .filter { [weak self] _ in
                guard let self else { return false }
                return self.notificationList.count >= 10
            }
            .sink { [weak self] _ in
                self?.fetchNotificationList(for: true)
            }
            .store(in: &cancellables)
    }
    
    func loadData(for centerLoading: Bool = false) {
        guard false == isSkeleton.value else { return }
        saveStartID = nil
        fetchNotificationList(for: centerLoading, more: false)
    }
    
    func fetchNotificationList(for centerLoading: Bool = false, isFirst: Bool = false, more: Bool = true) {
        if false == more {
            saveStartID = nil
        }
        
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
                let result = try await repository.fetchNotificationList(with: saveStartID)
                guard let result else { return }
                if false == more {
                    saveStartID = result.startID
                    notificationList = result.notificationList ?? []
                } else {
                    if saveStartID == nil {
                        notificationList = result.notificationList ?? []
                    } else {
                        var currentList = notificationList
                        currentList.append(contentsOf: result.notificationList ?? [])
                        notificationList = currentList
                        saveStartID = result.startID
                    }
                }
            } catch {
                handleError(error)
            }
        }
    }
    
    func removeNotification(with index: Int) async {
        do {
            if notificationList[index].status != .requestLink {
                let notificationID = notificationList[index].id
                try await repository.removeNotification(with: notificationID)
                removeData(for: notificationID)
            }
        } catch {
            handleError(error)
        }
    }
    
    func removeData(for notificationID: Int) {
        guard let index = notificationList.map( {$0.id}).firstIndex(of: notificationID) else { return }
        notificationList.remove(at: index)
    }
    
    func linkApproveDidTap(for memberID: Int) async {
        do {
            try await repository.approveLinkRequest(to: memberID)
            removeData(for: memberID)
        } catch {
            handleError(error)
        }
    }
    
    func linkRejectDidTap(for memberID: Int) async {
        do {
            try await repository.rejectLinkRequest(to: memberID)
            removeData(for: memberID)
        } catch {
            handleError(error)
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
    
    func resetBottomRefreshSubjects() {
        self.rechedBottomSubject.send(false)
    }
}
