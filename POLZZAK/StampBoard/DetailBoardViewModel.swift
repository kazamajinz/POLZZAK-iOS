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

final class DetailBoardRepository {
    private let stampBoardID: Int
    private let dataMapper = StampBoardDetailMapper()
    
    init(stampBoardID: Int) {
        self.stampBoardID = stampBoardID
    }
    
    func fetchStampBoardDetailInfo() async -> DetailBoardRepositoryResult {
        do {
            let (data, response) = try await StampBoardDetailAPI.getStampBoardDetail(stampBoardID: stampBoardID)
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return .emptyStatusCode }
            switch statusCode {
            case 200..<300:
                let dto = try JSONDecoder().decode(BaseResponseDTO<StampBoardDetailDTO>.self, from: data)
                guard let stampBoardDetailDTO = dto.data else { return .emptyData }
                let stampBoardDetail = dataMapper.mapStampBoardDetail(from: stampBoardDetailDTO)
                return .render(stampBoardDetail)
            default:
                return .fail(statusCode: statusCode)
            }
        } catch {
            if let urlError = error as? URLError {
                // TODO: URLError의 timedOut, networkConnectionLost, notConnectedToInternet에 대해 공통처리 하는 부분은 빼도 좋지 않을까?
                return .urlError(urlError)
            }
            os_log(log: .polzzakAPI, errorDescription: String(describing: error))
            return .unknown(error)
        }
    }
}

enum DetailBoardRepositoryResult {
    case render(StampBoardDetail)
    case fail(statusCode: Int, messages: String? = nil)
    case urlError(URLError)
    case emptyStatusCode
    case emptyData
    case unknown(Error)
}
