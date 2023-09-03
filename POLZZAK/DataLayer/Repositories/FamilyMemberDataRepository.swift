//
//  FamilyMemberDataRepository.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/30.
//

import Foundation

class FamilyMemberDataRepository: FamilyMemberRepository {
    private let linkManagementService: LinkManagementService
    private let familyMemberMapper = FamilyMemberMapper()
    private let linkManagementMapper = LinkManagementMapper()
    
    init(linkManagementService: LinkManagementService = LinkManagementService()) {
        self.linkManagementService = linkManagementService
    }
    
    func getUserByNickname(_ nickname: String) async throws -> FamilyMember? {
        let responseDTO = try await linkManagementService.fetchUserByNickname(nickname)
        return familyMemberMapper.map(from: responseDTO)
    }
    
    func getLinkedUsers() async throws -> [FamilyMember] {
        let responseDTO = try await linkManagementService.fetchAllLinkedUsers()
        return familyMemberMapper.map(from: responseDTO)
    }
    
    func getReceivedLinkRequests() async throws -> [FamilyMember] {
        let responseDTO = try await linkManagementService.fetchAllReceivedUsers()
        return familyMemberMapper.map(from: responseDTO)
    }
    
    func getSentLinkRequests() async throws -> [FamilyMember] {
        let responseDTO = try await linkManagementService.fetchAllRequestedUsers()
        return familyMemberMapper.map(from: responseDTO)
    }
    
    func createLinkRequest(to memberID: Int) async throws {
        _ = try await linkManagementService.sendLinkRequest(to: memberID)
    }
    
    func deleteSentLinkRequest(to memberID: Int) async throws {
        _ = try await linkManagementService.cancelLinkRequest(to: memberID)
    }

    func approveLinkRequest(to memberID: Int) async throws {
        _ = try await linkManagementService.approveLinkRequest(from: memberID)
    }
    
    func rejectLinkRequest(to memberID: Int) async throws {
        _ = try await linkManagementService.rejectLinkRequest(from: memberID)
    }
    
    func removeLink(with memberID: Int) async throws {
        _ = try await linkManagementService.sendUnlinkRequest(to: memberID)
    }
    
    func checkNewLinkRequest() async throws -> CheckLinkRequest? {
        let responseDTO = try await linkManagementService.checkNewLinkRequest()
        return linkManagementMapper.map(from: responseDTO)
    }
}
