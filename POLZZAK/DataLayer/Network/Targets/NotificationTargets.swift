//
//  NotificationTargets.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/10.
//

import Foundation

enum NotificationTargets {
    case fetchNotificationList(startID: Int?)
    case removeNotification(notificationID: Int)
}

extension NotificationTargets: BasicTargetType {
    var baseURL: String {
        return Constants.URL.baseURL
    }
    
    var path: String {
        switch self {
        case .fetchNotificationList, .removeNotification:
            return "v1/notifications"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchNotificationList:
            return .get
        case .removeNotification:
            return .delete
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return nil
        }
    }
    
    var queryParameters: Encodable? {
        var query = [String : Int]()
        switch self {
        case .fetchNotificationList(let startID):
            query["startId"] = startID
            return query
        case .removeNotification(let notificationID):
            query["notificationIds"] = notificationID
            return query
        }
    }
    
    var bodyParameters: Encodable? {
        switch self {
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
