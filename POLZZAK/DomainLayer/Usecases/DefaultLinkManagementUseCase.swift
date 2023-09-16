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

class DefaultLinkManagementUseCase: LinkManagementUseCase {
    let repository: LinkManagementRepository
    
    init(repository: LinkManagementRepository) {
        self.repository = repository
    }
    
    func searchUserByNickname(_ nickname: String) -> Task<FamilyMember?, Error> {
        return Task {
            do {
                let result = try await repository.getUserByNickname(nickname)
                switch result {
                case .success(let response):
                    return response?.data
                case .failure(let error):
                    throw error
                }
            } catch {
                throw error
            }
        }
    }
    
    func fetchAllLinkedUsers() -> Task<[FamilyMember], Error> {
        return Task {
            do {
                let result = try await self.repository.getLinkedUsers()
                switch result {
                case .success(let response):
                    return response?.data ?? []
                case .failure(let error):
                    throw error
                }
            } catch {
                throw error
            }
        }
    }
    
    func fetchAllReceivedLinkRequests() -> Task<[FamilyMember], Error> {
        return Task {
            do {
                let result = try await self.repository.getReceivedLinkRequests()
                switch result {
                case .success(let response):
                    return response?.data ?? []
                case .failure(let error):
                    throw error
                }
            } catch {
                throw error
            }
        }
    }
    
    func fetchAllSentLinkRequests() -> Task<[FamilyMember], Error> {
        return Task {
            do {
                let result = try await self.repository.getSentLinkRequests()
                switch result {
                case .success(let response):
                    return response?.data ?? []
                case .failure(let error):
                    throw error
                }
            } catch {
                throw error
            }
        }
    }
    
    func sendLinkRequest(to memberID: Int) -> Task<Void, Error> {
        return Task {
            do {
                let result = try await self.repository.createLinkRequest(to: memberID)
                switch result {
                case .success:
                    break
                case .failure(let error):
                    throw error
                }
            } catch {
                throw error
            }
        }
    }
    
    func cancelLinkRequest(to memberID: Int) -> Task<Void, Error> {
        return Task {
            do {
                let result = try await self.repository.deleteSentLinkRequest(to: memberID)
                switch result {
                case .success:
                    break
                case .failure(let error):
                    throw error
                }
            } catch {
                throw error
            }
        }
    }
    
    func approveReceivedLinkRequest(from memberID: Int) -> Task<Void, Error> {
        return Task {
            do {
                let result = try await self.repository.approveLinkRequest(to: memberID)
                switch result {
                case .success:
                    break
                case .failure(let error):
                    throw error
                }
            } catch {
                throw error
            }
        }
    }
    
    func rejectReceivedLinkRequest(from memberID: Int) -> Task<Void, Error> {
        return Task {
            do {
                let result = try await self.repository.rejectLinkRequest(to: memberID)
                switch result {
                case .success:
                    break
                case .failure(let error):
                    throw error
                }
            } catch {
                throw error
            }
        }
    }
    
    func sendUnlinkRequest(to memberID: Int) -> Task<Void, Error> {
        return Task {
            do {
                let result = try await self.repository.removeLink(with: memberID)
                switch result {
                case .success:
                    break
                case .failure(let error):
                    throw error
                }
            } catch {
                throw error
            }
        }
    }
    
    func checkNewLinkRequest() -> Task<CheckLinkRequest, Error> {
        return Task {
            do {
                let result = try await repository.checkNewLinkRequest()
                switch result {
                case .success(let response):
                    guard let data = response?.data else {
                        throw NetworkError.emptyReponse
                    }
                    return data
                case .failure(let error):
                    throw error
                }
            } catch {
                throw error
            }
        }
    }
}

extension DefaultLinkManagementUseCase {
    private func performTask<T>(_ task: @escaping () async throws -> T) -> Task<T, Error> {
        return Task {
            do {
                return try await task()
            } catch {
                throw error
            }
        }
    }
}
