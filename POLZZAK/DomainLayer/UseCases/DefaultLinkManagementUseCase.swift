//
//  DefaultLinkManagementUseCase.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/30.
//

import Foundation
import Combine

protocol LinkManagementUseCase {
    func searchUserByNickname(_ nickname: String) -> Task<FamilyMember?, Error>
    func fetchAllLinkedUsers() -> Task<[FamilyMember], Error>
    func fetchAllReceivedLinkRequests() -> Task<[FamilyMember], Error>
    func fetchAllSentLinkRequests() -> Task<[FamilyMember], Error>
    func sendLinkRequest(to memberID: Int) -> Task<Void, Error>
    func cancelLinkRequest(to memberID: Int) -> Task<Void, Error>
    func approveReceivedLinkRequest(from memberID: Int) -> Task<Void, Error>
    func rejectReceivedLinkRequest(from memberID: Int) -> Task<Void, Error>
    func sendUnlinkRequest(to memberID: Int) -> Task<Void, Error>
    func checkNewLinkRequest() -> Task<CheckLinkRequest, Error>
}

class DefaultLinkManagementUseCase: UseCaseProtocol, LinkManagementUseCase {
    let repository: LinkManagementRepository
    
    init(repository: LinkManagementRepository) {
        self.repository = repository
    }
    
    func searchUserByNickname(_ nickname: String) -> Task<FamilyMember?, Error> {
        return Task {
            let result = try await repository.getUserByNickname(nickname)
            return try processResult(result)
        }
    }
    
    func fetchAllLinkedUsers() -> Task<[FamilyMember], Error> {
        return Task {
            let result = try await repository.getLinkedUsers()
            return try processResult(result) ?? []
        }
    }
    
    func fetchAllReceivedLinkRequests() -> Task<[FamilyMember], Error> {
        return Task {
            let result = try await repository.getReceivedLinkRequests()
            return try processResult(result) ?? []
        }
    }
    
    func fetchAllSentLinkRequests() -> Task<[FamilyMember], Error> {
        return Task {
            let result = try await repository.getSentLinkRequests()
            return try processResult(result) ?? []
        }
    }
    
    func sendLinkRequest(to memberID: Int) -> Task<Void, Error> {
        return Task {
            let result = try await repository.createLinkRequest(to: memberID)
            _ = try processResult(result)
        }
    }
    
    func cancelLinkRequest(to memberID: Int) -> Task<Void, Error> {
        return Task {
            let result = try await repository.deleteSentLinkRequest(to: memberID)
            _ = try processResult(result)
        }
    }
    
    func approveReceivedLinkRequest(from memberID: Int) -> Task<Void, Error> {
        return Task {
            let result = try await repository.approveLinkRequest(to: memberID)
            _ = try processResult(result)
        }
    }
    
    func rejectReceivedLinkRequest(from memberID: Int) -> Task<Void, Error> {
        return Task {
            let result = try await repository.rejectLinkRequest(to: memberID)
            _ = try processResult(result)
        }
    }
    
    func sendUnlinkRequest(to memberID: Int) -> Task<Void, Error> {
        return Task {
            let result = try await repository.removeLink(with: memberID)
            _ = try processResult(result)
        }
    }
    
    func checkNewLinkRequest() -> Task<CheckLinkRequest, Error> {
        return Task {
            let result = try await repository.checkNewLinkRequest()
            guard let responseData = try processResult(result) else {
                throw NetworkError.emptyReponse
            }
            return responseData
        }
    }
}
