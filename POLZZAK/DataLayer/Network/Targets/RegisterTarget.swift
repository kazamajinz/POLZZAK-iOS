//
//  RegisterTarget.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/19.
//

import Foundation
import UIKit

enum RegisterTargetError: LocalizedError {
    case noRegsiterData
    case cannotConvertToPNG
    
    var errorDescription: String? {
        switch self {
        case .noRegsiterData: return "register data가 비었습니다."
        case .cannotConvertToPNG: return "image를 PNG로 변한할 수 없습니다."
        }
    }
}

enum RegisterTarget {
    case register(username: String, socialType: String, memberType: Int, nickname: String)
    case registerWithImage(username: String, socialType: String, memberType: Int, nickname: String, image: UIImage)
}

extension RegisterTarget: MultipartFormTargetType {
    var baseURL: String {
        return Constants.URL.baseURL
    }
    
    var path: String {
        return "v1/auth/register"
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var queryParameters: Encodable? {
        return nil
    }
    
    var sampleData: Data? {
        return nil
    }
    
    var formData: [FormData]? {
        get throws {
            switch self {
            case .register(let username, let socialType, let memberType, let nickname):
                let dict: [String: Any] = [
                    "username": username,
                    "socialType": socialType,
                    "memberTypeDetailId": memberType,
                    "nickname": nickname
                ]
                let data = try JSONSerialization.data(withJSONObject: dict)
                let registerData = FormData(
                    name: "registerRequest",
                    filename: "registerRequest",
                    contentType: "application/json",
                    data: data
                )
                
                return [registerData]
            case .registerWithImage(let username, let socialType, let memberType, let nickname, let image):
                let registerData = try RegisterTarget.register(
                    username: username,
                    socialType: socialType,
                    memberType: memberType,
                    nickname: nickname
                ).formData?.first
                
                guard let registerData else { throw RegisterTargetError.noRegsiterData }
                guard let pngImage = image.resize(newWidth: 100).pngData() else { throw RegisterTargetError.cannotConvertToPNG }
                
                let imageData = FormData(
                    name: "profile",
                    filename: "\(UUID().uuidString).png",
                    contentType: "image/png",
                    data: pngImage
                )
                
                return [registerData, imageData]
            }
        }
    }
}
