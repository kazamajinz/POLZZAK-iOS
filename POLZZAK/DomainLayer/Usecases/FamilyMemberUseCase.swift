//
//  FamilyMemberUseCase.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/30.
//

import Foundation
import Combine

protocol FamilyMemberUseCase {
    func searchUserByNickname(_ nickname: String) -> AnyPublisher<FamilyMember?, Error>
    func fetchAllLinkedUsers() -> AnyPublisher<[FamilyMember], Error>
    func fetchAllReceivedLinkRequests() -> AnyPublisher<[FamilyMember], Error>
    func fetchAllSentLinkRequests() -> AnyPublisher<[FamilyMember], Error>
    func sendLinkRequest(to memberID: Int) -> AnyPublisher<Void, Error>
    func cancelLinkRequest(to memberID: Int) -> AnyPublisher<Void, Error>
    func approveReceivedLinkRequest(from memberID: Int) -> AnyPublisher<Void, Error>
    func rejectReceivedLinkRequest(from memberID: Int) -> AnyPublisher<Void, Error>
    func sendUnlinkRequest(to memberID: Int) -> AnyPublisher<Void, Error>
    func checkNewLinkRequest() -> AnyPublisher<CheckLinkRequest?, Error>
}

class DefaultFamilyMemberUseCase: FamilyMemberUseCase {
    let repository: FamilyMemberRepository
    
    init(repository: FamilyMemberRepository) {
        self.repository = repository
    }
    
    func searchUserByNickname(_ nickname: String) -> AnyPublisher<FamilyMember?, Error> {
        return performTask {
            try await self.repository.getUserByNickname(nickname)
        }
    }
    
    func fetchAllLinkedUsers() -> AnyPublisher<[FamilyMember], Error> {
        return performTask {
            try await self.repository.getLinkedUsers()
        }
    }
    
    func fetchAllReceivedLinkRequests() -> AnyPublisher<[FamilyMember], Error> {
        return performTask {
            try await self.repository.getReceivedLinkRequests()
        }
    }
    
    func fetchAllSentLinkRequests() -> AnyPublisher<[FamilyMember], Error> {
        return performTask {
            try await self.repository.getSentLinkRequests()
        }
    }
    
    func sendLinkRequest(to memberID: Int) -> AnyPublisher<Void, Error> {
        return performTask {
            try await self.repository.createLinkRequest(to: memberID)
        }
    }
    
    func cancelLinkRequest(to memberID: Int) -> AnyPublisher<Void, Error> {
        return performTask {
            try await self.repository.deleteSentLinkRequest(to: memberID)
        }
    }
    
    func approveReceivedLinkRequest(from memberID: Int) -> AnyPublisher<Void, Error> {
        return performTask {
            try await self.repository.approveLinkRequest(to: memberID)
        }
    }
    
    func rejectReceivedLinkRequest(from memberID: Int) -> AnyPublisher<Void, Error> {
        return performTask {
            try await self.repository.rejectLinkRequest(to: memberID)
        }
    }
    
    func sendUnlinkRequest(to memberID: Int) -> AnyPublisher<Void, Error> {
        return performTask {
            try await self.repository.removeLink(with: memberID)
        }
    }
    
    func checkNewLinkRequest() -> AnyPublisher<CheckLinkRequest?, Error> {
        return performTask {
            try await self.repository.checkNewLinkRequest()
        }
    }
}

extension DefaultFamilyMemberUseCase {
    private func performTask<T>(_ task: @escaping () async throws -> T) -> AnyPublisher<T, Error> {
        return Future { promise in
            Task {
                do {
                    let result = try await task()
                    promise(.success(result))
                } catch {
                    if let networkError = error as? NetworkError {
                        promise(.failure(networkError))
                    } else {
                        promise(.failure(error))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
}
