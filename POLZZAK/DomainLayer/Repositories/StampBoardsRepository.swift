//
//  StampBoardsRepository.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/07.
//

import Foundation

protocol StampBoardsRepository {
    func getStampBoardList(for tabState: String) async throws -> NetworkResult<BaseResponse<[StampBoardList]>, NetworkError>
}
