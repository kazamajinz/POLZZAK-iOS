//
//  LinkRequestUseCase.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/14.
//

import Foundation

protocol LinkRequestRepositoryProtocol {
    func approveLinkRequest(to memberID: Int) async throws -> Result<Void, Error>
    func rejectLinkRequest(to memberID: Int) async throws -> Result<Void, Error>
}

protocol LinkRequestManagement {
    var repository: LinkRequestRepositoryProtocol { get }

    func approveReceivedLinkRequest(from memberID: Int) -> Task<Void, Error>
    func rejectReceivedLinkRequest(from memberID: Int) -> Task<Void, Error>
}

extension LinkRequestManagement {
    func approveReceivedLinkRequest(from memberID: Int) -> Task<Void, Error> {
        return Task {
            do {
                let result = try await repository.approveLinkRequest(to: memberID)
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
                let result = try await repository.rejectLinkRequest(to: memberID)
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
}
