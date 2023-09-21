//
//  StampBoardsService.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/07.
//

import Foundation

protocol StampBoardsService {
    func fetchStampBoardList(for tabState: TabState) async throws -> (Data, URLResponse)
}

class DefaultStampBoardsService: StampBoardsService, NetworkServiceResponseHandler {
    var networkService: NetworkServiceProvider
    
    init(networkService: NetworkServiceProvider = NetworkService(requestInterceptor: TokenInterceptor())) {
        self.networkService = networkService
    }
    
    func fetchStampBoardList(for tabState: TabState) async throws -> (Data, URLResponse) {
        return try await handleResponse(StampBoardsTargets.fetchStampBoardList(tabState: tabState))
    }
}
