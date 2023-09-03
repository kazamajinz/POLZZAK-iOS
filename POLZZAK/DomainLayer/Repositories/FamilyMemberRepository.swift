//
//  FamilyMemberRepository.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/30.
//

import Foundation

protocol FamilyMemberRepository {
    func getUserByNickname(_ nickname: String) async throws -> FamilyMember?
    func getLinkedUsers() async throws -> [FamilyMember]
    func getReceivedLinkRequests() async throws -> [FamilyMember]
    func getSentLinkRequests() async throws -> [FamilyMember]
    func createLinkRequest(to memberID: Int) async throws
    func deleteSentLinkRequest(to memberID: Int) async throws
    func approveLinkRequest(to memberID: Int) async throws
    func rejectLinkRequest(to memberID: Int) async throws
    func removeLink(with memberID: Int) async throws
    func checkNewLinkRequest() async throws -> CheckLinkRequest?
}
