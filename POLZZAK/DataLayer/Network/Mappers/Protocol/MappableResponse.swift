//
//  MappableResponse.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/16.
//

import Foundation

protocol Mappable {
    func mapBaseResponse<T, U>(from dto: BaseResponseDTO<T>, transform: (T) -> U) -> BaseResponse<U>
    func mapEmptyDataResponse(from response: BaseResponseDTO<EmptyDataResponseDTO>) -> BaseResponse<EmptyDataResponse>
}

extension Mappable {
    func mapBaseResponse<T, U>(from dto: BaseResponseDTO<T>, transform: (T) -> U) -> BaseResponse<U> {
        let transformedData = dto.data.map(transform)
        return BaseResponse(code: dto.code, messages: dto.messages, data: transformedData)
    }
    
    func mapEmptyDataResponse(from response: BaseResponseDTO<EmptyDataResponseDTO>) -> BaseResponse<EmptyDataResponse> {
        return BaseResponse(code: response.code, messages: response.messages, data: nil)
    }
}
