//
//  AppleLoginManager.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/20.
//

import AuthenticationServices
import UIKit

final class AppleLoginManager: NSObject {
    weak var viewController: UIViewController?
    var loginContinuation: CheckedContinuation<ASAuthorization, Error>?
    
    func setAppleLoginPresentationAnchorView(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func login(authorizationRequests: [ASAuthorizationRequest]) async throws -> ASAuthorization {
        try await withCheckedThrowingContinuation { continuation in
            loginContinuation = continuation
            let authorizationController = ASAuthorizationController(authorizationRequests: authorizationRequests)
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }
}

extension AppleLoginManager: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return viewController!.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        loginContinuation?.resume(returning: authorization)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        loginContinuation?.resume(throwing: error)
    }
}
