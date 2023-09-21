//
//  StampBoardsDataRepository.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/07.
//

import Foundation

protocol StampBoardsRepository {
    func getStampBoardList(for tabState: TabState) async throws -> [StampBoardList]
}

final class StampBoardsDataRepository: DataRepositoryProtocol, StampBoardsRepository {
    typealias MapperType = DefaultStampBoardsMapper
    let mapper: MapperType = DefaultStampBoardsMapper()
    
    private let service: StampBoardsService
    
    init(stampBoardsService: StampBoardsService = DefaultStampBoardsService()) {
        self.service = stampBoardsService
    }
    
    func getStampBoardList(for tabState: TabState) async throws -> [StampBoardList] {
        let response: BaseResponse<[StampBoardList]> = try await fetchData(
            using: { try await service.fetchStampBoardList(for: tabState) },
            decodingTo: BaseResponseDTO<[StampBoardListDTO]>.self,
            map: mapper.mapStampBoardListResponse
        )
        return response.data ?? []
    }
}
