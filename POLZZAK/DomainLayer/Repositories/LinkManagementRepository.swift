//
//  LinkManagementRepository.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/30.
//

import Foundation

protocol LinkManagementRepository {
    func getUserByNickname(_ nickname: String) async throws -> NetworkResult<BaseResponse<FamilyMember>, NetworkError>
    func getLinkedUsers() async throws -> NetworkResult<BaseResponse<[FamilyMember]>, NetworkError>
    func getReceivedLinkRequests() async throws -> NetworkResult<BaseResponse<[FamilyMember]>, NetworkError>
    func getSentLinkRequests() async throws -> NetworkResult<BaseResponse<[FamilyMember]>, NetworkError>
    func createLinkRequest(to memberID: Int) async throws -> NetworkResult<BaseResponse<EmptyDataResponse>, NetworkError>
    func deleteSentLinkRequest(to memberID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
    func approveLinkRequest(to memberID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
    func rejectLinkRequest(to memberID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
    func removeLink(with memberID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
    func checkNewLinkRequest() async throws -> NetworkResult<BaseResponse<CheckLinkRequest>, NetworkError>
}
