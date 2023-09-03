//
//  LinkManagementMapper.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/03.
//

import Foundation

struct LinkManagementMapper {
    func map(from response: BaseResponseDTO<CheckLinkRequestResponseDTO>) -> CheckLinkRequest? {
        guard let data = response.data else {
            return nil
        }
        
        return map(from: data)
    }
    
    func map(from dto: CheckLinkRequestResponseDTO) -> CheckLinkRequest {
        return CheckLinkRequest(
            isFamilyReceived: dto.isFamilyReceived,
            isFamilySent: dto.isFamilySent
        )
    }
}
