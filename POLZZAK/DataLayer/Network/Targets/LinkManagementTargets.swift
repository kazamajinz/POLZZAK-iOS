//
//  LinkManagementTargets.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/30.
//

import Foundation

enum LinkManagementTargets {
    case searchUserByNickname(_ nickname: String)
    case fetchAllLinkedUsers
    case fetchAllReceivedLinkRequests
    case fetchAllSentLinkRequests
    case sendLinkRequest(memberID: Int)
    case cancelSentLinkRequest(memberID: Int)
    case approveReceivedLinkRequest(memberID: Int)
    case rejectReceivedLinkRequest(memberID: Int)
    case requestUnLink(memberID: Int)
    case checkNewLinkRequest
}

extension LinkManagementTargets: BasicTargetType {
    var baseURL: String {
        return Constants.URL.baseURL
    }
    
    var path: String {
        switch self {
        case .searchUserByNickname:
            return "v1/families/users"
        case .fetchAllLinkedUsers:
            return "v1/families"
        case .fetchAllReceivedLinkRequests:
            return "v1/families/requests/received"
        case .fetchAllSentLinkRequests:
            return "v1/families/requests/sent"
        case .sendLinkRequest:
            return "v1/families"
        case .cancelSentLinkRequest(let memberID):
            return "v1/families/cancel/\(memberID)"
        case .approveReceivedLinkRequest(let memberID):
            return "v1/families/approve/\(memberID)"
        case .rejectReceivedLinkRequest(let memberID):
            return "v1/families/reject/\(memberID)"
        case .requestUnLink(let memberID):
            return "v1/families/\(memberID)"
        case .checkNewLinkRequest:
            return "v1/families/new-request-mark"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchAllLinkedUsers, .fetchAllReceivedLinkRequests, .fetchAllSentLinkRequests, .searchUserByNickname, .checkNewLinkRequest:
            return .get
        case .cancelSentLinkRequest, .rejectReceivedLinkRequest, .requestUnLink:
            return .delete
        case .sendLinkRequest:
            return .post
        case .approveReceivedLinkRequest:
            return .patch
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .sendLinkRequest:
            return ["Content-Type": "application/json"]
        default:
            return nil
        }
    }
    
    var queryParameters: Encodable? {
        var query = [String : String]()
        switch self {
        case .searchUserByNickname(let nickname):
            query["nickname"] = nickname
            return query
        default:
            return nil
        }
    }
    
    var bodyParameters: Encodable? {
        switch self {
        case .sendLinkRequest(let memberID):
            return ["targetId" : memberID]
        default:
            return nil
        }
    }
    
    var sampleData: Data? {
        switch self {
        default:
            return nil
        }
    }
}
