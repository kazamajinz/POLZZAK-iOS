//
//  LinkManagementViewModel.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/29.
//

import Foundation
import Combine

final class LinkManagementViewModel {
    private let useCase: FamilyMemberUseCase
    private var cancellables = Set<AnyCancellable>()
    
    var userType: UserType = .child
    @Published var dataList: [FamilyMember] = []
    @Published var isTabLoading: Bool = true
    @Published var linkTabState: LinkTabState = .linkListTab
    @Published var searchState: SearchState = .inactive
    @Published var searchResultState: SearchResultState = .notSearch
    
    
    var searchResultSubject = PassthroughSubject<(String, FamilyMember?), Never>()
    var showErrorAlertSubject = PassthroughSubject<String?, Never>()
    var toastAppearSubject = PassthroughSubject<ToastType, Never>()
    
    init(useCase: FamilyMemberUseCase) {
        self.useCase = useCase
        
        //TODO: - DTO에서 Model로 변환할때 UserType을 단순하게 부모인지 아이인지 변환하고 UserInfo에서 사용하는 Model에 userType을 추가했으면 좋겠음.
        let userInfo = UserInfoManager.readUserInfo()
        userType = (userInfo?.memberType.detail == "아이" ? .child : .parent)
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        searchResultSubject
            .sink { [weak self] (nickname, member) in
                self?.handleSearchResult(nickname, member)
            }
            .store(in: &cancellables)
    }
    
    func searchUserByNickname(_ nickname: String) {
        updateSearchState(to: .searching(nickname))
        useCase.searchUserByNickname(nickname)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.handleError(error)
                }
            } receiveValue: { [weak self] result in
                self?.updateSearchState(to: .completed)
                self?.searchResultSubject.send((nickname, result))
                
            }
            .store(in: &cancellables)
    }
    
    func fetchAllLinkedUsers() {
        Task {
            await loadMembers(using: useCase.fetchAllLinkedUsers)
        }
    }
    
    func fetchAllReceivedLinkRequests() {
        Task {
            await loadMembers(using: useCase.fetchAllReceivedLinkRequests)
        }
    }
    
    func fetchAllSentLinkRequests() {
        Task {
            await loadMembers(using: useCase.fetchAllSentLinkRequests)
        }
    }
    
    func loadMembers(using useCaseFetchMethod: () -> AnyPublisher<[FamilyMember], Error>) async {
        showLoading()
        useCaseFetchMethod()
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    self.handleError(error)
                }
            } receiveValue: { members in
                self.dataList = members
            }
            .store(in: &cancellables)
    }
    
    func checkNewLinkRequest() async {
        useCase.checkNewLinkRequest()
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    self.handleError(error)
                }
                self.hideLoading()
            } receiveValue: { newAlert in
//                self.dataList = members
            }
            .store(in: &cancellables)
    }
    
    func linkRequestDidTap(for memberID: Int) async {
        useCase.sendLinkRequest(to: memberID)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.searchResultState = .linkRequestCompleted(nil)
                    print("이거 된건가")
                case .failure(let error):
                    self?.handleError(error)
                    if let polzzakError = error as? PolzzakError, polzzakError.statusCode == 400 {
                        self?.toastAppearSubject.send(.error("이미 해당 회원에게 연동 요청을 받았어요"))
                        
                        //TODO: - 이거 하면 변동시켜줌, 검토해볼만함.
                        self?.searchResultState = .linkRequestCompleted(nil)
                    }
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    func linkCancelDidTap(for memberID: Int) async {
        useCase.cancelLinkRequest(to: memberID)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.removeData(for: memberID)
                case .failure(let error):
                    self?.handleError(error)
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    func linkApproveDidTap(for memberID: Int) async {
        useCase.approveReceivedLinkRequest(from: memberID)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.removeData(for: memberID)
                case .failure(let error):
                    self?.handleError(error)
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    func linkRejectDidTap(for memberID: Int) async {
        useCase.rejectReceivedLinkRequest(from: memberID)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.removeData(for: memberID)
                case .failure(let error):
                    self?.handleError(error)
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    func unlinkRequestDidTap(for memberID: Int) async {
        useCase.sendUnlinkRequest(to: memberID)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.removeData(for: memberID)
                case .failure(let error):
                    self?.handleError(error)
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    func removeData(for memberID: Int) {
        guard let index = dataList.map({$0.memberID}).firstIndex(of: memberID) else { return }
        dataList.remove(at: index)
    }
    
    
    func handleSearchResult(_ nickname: String, _ result: FamilyMember?) {
        guard let result, let familyStatus = result.familyStatus else {
            print("회원정보 없습니다.")
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
        //        cancelAllTasks()
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
        showErrorAlertSubject.send(error.description)
    }
    
    private func handleNetworkError(_ error: NetworkError) {
        showErrorAlertSubject.send(error.errorDescription)
    }
    
    private func handleDecodingError(_ error: DecodingError) {
        showErrorAlertSubject.send(error.description)
    }
    
    private func handleUnknownError(_ error: Error) {
        showErrorAlertSubject.send(error.localizedDescription)
    }
    
    
    private func cancelAllTasks() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func cancelLinkRequest() {
        
    }
}
