//
//  HTTPStatus.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/31.
//

import Foundation

enum PolzzakError: Int, Error {
    case ok = 200
    case created = 201
    case noContent = 204
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case requestResourceNotValid = 410
    case oauthAuthenticationFail = 411
    case requiredRegister = 412
    case accessTokenInvalid = 431
    case refreshTokenInvalid = 432
    case accessTokenExpired = 433
    case tokenReissueSuccess = 434
    case tokenUnauthorized = 435
    case fileUploadFail = 450
    case findFileFail = 451
    case deleteFileFail = 452
    case unknwon = 500
    
    var statusCode: Int {
        return self.rawValue
    }
    
    var description: String {
        switch self {
        case .ok: return "OK - Success"
        case .created: return "CREATED - Success Created"
        case .noContent: return "NO_CONTENT - Success"
        case .badRequest: return "BAD_REQUEST - Bad request / Request is invalid"
        case .unauthorized: return "UNAUTHORIZED - Token is invalid / Unauthenticated Access"
        case .forbidden: return "FORBIDDEN - Permission is invalid"
        case .requestResourceNotValid: return "REQUEST_RESOURCE_NOT_VALID - Request resource is invalid"
        case .oauthAuthenticationFail: return "OAUTH_AUTHENTICATION_FAIL - Social Login failed"
        case .requiredRegister: return "REQUIRED_REGISTER - Register is required"
        case .accessTokenInvalid: return "ACCESS_TOKEN_INVALID - AccessToken is invalid"
        case .refreshTokenInvalid: return "REFRESH_TOKEN_INVALID - RefreshToken is invalid"
        case .accessTokenExpired: return "ACCESS_TOKEN_EXPIRED - AccessToken has expired"
        case .tokenReissueSuccess: return "TOKEN_REISSUE_SUCCESS - Success token reissue"
        case .tokenUnauthorized: return "TOKEN_UNAUTHORIZED - Request not authorized"
        case .fileUploadFail: return "FILE_UPLOAD_FAIL - Failed to upload file"
        case .findFileFail: return "FIND_FILE_FAIL - Failed to locate file"
        case .deleteFileFail: return "DELETE_FILE_FAIL - Failed to delete file"
        case .unknwon: return "정의되지 않은 에러"
        }
    }
}

extension PolzzakError {
    static func validate(code: Int) throws {
        if 200..<300 ~= code {
            return
        }
        
        if let status = PolzzakError(rawValue: code), status != .ok {
            throw status
        }
    }
}
