//
//  DetailBoardViewModel.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/18.
//

import Combine
import Foundation

final class DetailBoardViewModel {
    enum Action {
        case load
    }
    
    // ???: ReactorKit처럼 Mutate가 필요한건지 생각해보기
    enum Mutate {
        
    }
    
    final class State {
        @Published fileprivate(set) var stampBoardDetail: StampBoardDetail?
    }
    
    let action = PassthroughSubject<Action, Never>()
    let state = State()
    
    private var cancellables = Set<AnyCancellable>()
    private let repository: DetailBoardRepository
    
    init(stampBoardID: Int) {
        self.repository = DetailBoardRepository(stampBoardID: stampBoardID)
        bind()
    }
    
    private func bind() {
        action.sink { [weak self] action in
            guard let self else { return }
            switch action {
            case .load:
                fetchStampBoardDetailInfo()
            }
        }
        .store(in: &cancellables)
    }
    
    private func fetchStampBoardDetailInfo() {
        Task {
            let result = await repository.fetchStampBoardDetailInfo()
            switch result {
            case .render(let stampBoardDetail):
                state.stampBoardDetail = stampBoardDetail
            default:
                break
            }
        }
    }
    
    private func getMemberType() {
        guard let userInfo = UserInfoManager.readUserInfo() else { return }
        userInfo.memberType
    }
}
