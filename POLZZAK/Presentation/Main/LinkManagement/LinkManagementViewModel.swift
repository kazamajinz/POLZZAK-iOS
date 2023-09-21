//
//  LinkManagementViewModel.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/29.
//

import Foundation
import Combine

final class LinkManagementViewModel {
    private let repository: LinkManagementDataRepository
    private var cancellables = Set<AnyCancellable>()
    
    var userType: UserType
    @Published var dataList: [FamilyMember] = []
    @Published var isTabLoading: Bool = true
    @Published var linkTabState: LinkTabState = .linkListTab
    @Published var searchState: SearchState = .inactive
    @Published var searchResultState: SearchResultState = .notSearch
    
    var newAlertSubject = PassthroughSubject<CheckLinkRequest?, Never>()
    var showErrorAlertSubject = PassthroughSubject<Error, Never>()
    var toastAppearSubject = PassthroughSubject<ToastType, Never>()
    
    var searchTask: Task<FamilyMember?, Error>?
    
    init(repository: LinkManagementDataRepository) {
        self.repository = repository
        
        //TODO: - DTO에서 Model로 변환할때 UserType을 단순하게 부모인지 아이인지 변환하고 UserInfo에서 사용하는 Model에 userType을 추가했으면 좋겠음.
        let userInfo = UserInfoManager.readUserInfo()
        userType = (userInfo?.memberType.detail == "아이" ? .child : .parent)
    }
    
    func searchUserByNickname(_ nickname: String) async {
        updateSearchState(to: .searching(nickname))
        do {
            let result = try await repository.getUserByNickname(nickname)
            updateSearchState(to: .completed)
            handleSearchResult(nickname, result)
        } catch {
            handleError(error)
        }
    }

    private func fetchAllLinkedUsers() {
        loadMembers(using: repository.getLinkedUsers)
    }
    
    private func fetchAllReceivedLinkRequests() {
        loadMembers(using: repository.getReceivedLinkRequests)
    }
    
    private func fetchAllSentLinkRequests() {
        loadMembers(using: repository.getSentLinkRequests)
    }
    
    private func loadMembers(using repositoryFetchMethod: @escaping () async throws -> [FamilyMember]) {
        Task {
            showLoading()
            do {
                dataList = try await repositoryFetchMethod()
                await checkNewLinkRequest()
            } catch {
                handleError(error)
            }
        }
    }
    
    func checkNewLinkRequest() async {
        do {
            let result = try await repository.checkNewLinkRequest()
            newAlertSubject.send(result)
        } catch {
            handleError(error)
        }
        hideLoading()
    }
    
    func linkRequestDidTap(for memberID: Int) async {
        do {
            _ = try await repository.createLinkRequest(to: memberID)
            searchResultState = .linkRequestCompleted(nil)
        } catch {
            handleError(error)
        }
    }
    
    func linkCancelDidTap(for memberID: Int) async {
        do {
            try await repository.deleteSentLinkRequest(to: memberID)
            removeData(for: memberID)
        } catch {
            handleError(error)
        }
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
    
    func unlinkRequestDidTap(for memberID: Int) async {
        do {
            try await repository.removeLink(with: memberID)
            removeData(for: memberID)
        } catch {
            handleError(error)
        }
    }
    
    func removeData(for memberID: Int) {
        guard let index = dataList.map({$0.memberID}).firstIndex(of: memberID) else { return }
        dataList.remove(at: index)
    }
    
    func handleSearchResult(_ nickname: String, _ result: FamilyMember?) {
        guard let result, let familyStatus = result.familyStatus else {
            setNonExist(nickname)
            return
        }
        
        switch familyStatus {
        case .none:
            searchResultState = .unlinked(result)
        case .received:
            searchResultState = .unlinked(result)
        case .sent:
            searchResultState = .linkRequestCompleted(result)
        case .approve:
            searchResultState = .linked(result)
        }
    }

    func updateSearchState(to state: SearchState) {
        searchState = state
    }
    
    func setUnlinked(for member: FamilyMember) {
        searchResultState = .unlinked(member)
    }
    
    func setLinked(for member: FamilyMember) {
        searchResultState = .linked(member)
    }
    
    func setLinkeRequestCompleted(for member: FamilyMember) {
        searchResultState = .linkRequestCompleted(member)
    }
    
    func setNonExist(_ nickname: String) {
        searchResultState = .nonExist(nickname)
    }
    
    func showLoading() {
        isTabLoading = true
    }
    
    func hideLoading() {
        isTabLoading = false
    }
    
    func linkListTabTapped() {
        linkTabState = .linkListTab
    }
    
    func receivedTabTapped() {
        linkTabState = .receivedTab
    }
    
    func sentTabTapped() {
        linkTabState = .sentTab
    }
    
    func handleTabState(for tabState: LinkTabState) {
        switch tabState {
        case .linkListTab:
            fetchAllLinkedUsers()
        case .receivedTab:
            fetchAllReceivedLinkRequests()
        case .sentTab:
            fetchAllSentLinkRequests()
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
    
    
    private func cancelAllTasks() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func cancelSearchRequest() {
        searchState = .activated
        searchTask?.cancel()
        searchTask = nil
    }
}

extension Task {
    func store(in set: inout Set<AnyCancellable>) {
        set.insert(AnyCancellable(cancel))
    }
}
