//
//  StampBoardsDataRepository.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/07.
//

import Foundation

class StampBoardsDataRepository: DataRepositoryProtocol, StampBoardsRepository {
    typealias MapperType = StampBoardsMapper
    let mapper: MapperType = StampBoardsMapper()
    
    private let service: StampBoardsService
    
    init(stampBoardsService: StampBoardsService = StampBoardsService()) {
        self.service = stampBoardsService
    }
    
    func getStampBoardList(for tabState: String) async throws -> NetworkResult<BaseResponse<[StampBoardList]>, NetworkError> {
        return try await fetchData(
            using: { try await service.fetchStampBoardList(for: tabState) },
            decodingTo: BaseResponseDTO<[StampBoardListDTO]>.self,
            map: { mapper.mapStampBoardListResponse(from: $0) }
        )
    }
}
