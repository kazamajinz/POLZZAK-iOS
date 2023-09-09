//
//  StampBoardsDataRepository.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/07.
//

import Foundation

class StampBoardsDataRepository: StampBoardsRepository {
    private let stampBoardsService: StampBoardsService
    private let stampBoardsMapper = StampBoardsMapper()
    
    init(stampBoardsService: StampBoardsService = StampBoardsService()) {
        self.stampBoardsService = stampBoardsService
    }
    
    func getStampBoardList(for tabState: String) async throws -> NetworkResult<BaseResponse<[StampBoardList]>, NetworkError> {
        let (data, response) = try await stampBoardsService.fetchStampBoardList(for: tabState)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        let statusCode = httpResponse.statusCode
        switch statusCode {
        case 200..<300:
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(BaseResponseDTO<[StampBoardListDTO]>.self, from: data)
            let mapData = stampBoardsMapper.mapStampBoardListResponse(from: decodedData)
            return .success(mapData)
        default:
            throw NetworkError.serverError(statusCode)
        }
    }
}
