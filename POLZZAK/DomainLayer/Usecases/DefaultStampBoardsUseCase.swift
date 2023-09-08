//
//  DefaultStampBoardsUseCase.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/07.
//

import Foundation
import Combine

protocol StampBoardsUseCase {
    func fetchStampBoardList(_ tabState: String) -> Task<[StampBoardList], Error>
}

class DefaultStampBoardsUseCase: StampBoardsUseCase {
    let repository: StampBoardsRepository
    
    init(repository: StampBoardsRepository) {
        self.repository = repository
    }
    
    func fetchStampBoardList(_ tabState: String) -> Task<[StampBoardList], Error> {
        return Task {
            do {
                let result = try await repository.getStampBoardList(tabState)
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
}
