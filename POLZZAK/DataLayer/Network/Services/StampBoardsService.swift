//
//  StampBoardsService.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/07.
//

import Foundation

class StampBoardsService {
    private let networkService: NetworkServiceProvider
    
    init(networkService: NetworkServiceProvider = NetworkService(requestInterceptor: TokenInterceptor())) {
        self.networkService = networkService
    }
    
    func fetchStampBoardList(_ tabState: String) async throws -> (Data, URLResponse) {
        return try await networkService.request(with: StampBoardsTargets.fetchStampBoardList(tabState))
    }
}
