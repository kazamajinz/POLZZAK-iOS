//
//  DefaultStampBoardsUseCase.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/07.
//

import Foundation

protocol StampBoardsUseCase {
    func fetchStampBoardList(for tabState: String) -> Task<[StampBoardList], Error>
}

class DefaultStampBoardsUseCase: UseCaseProtocol, StampBoardsUseCase {
    var repository: StampBoardsRepository
    
    init(repository: StampBoardsRepository) {
        self.repository = repository
    }
    
    func fetchStampBoardList(for tabState: String) -> Task<[StampBoardList], Error> {
        return Task {
            let result = try await repository.getStampBoardList(for: tabState)
            return try processResult(result) ?? []
        }
    }
}
