//
//  ErrorHandlingProtocol.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/19.
//

import Combine
import os.log
import Foundation

protocol ErrorHandlingProtocol {
    var showErrorAlertSubject: PassthroughSubject<Error, Never> { get }
    func handleError(_ error: Error)
}

extension ErrorHandlingProtocol {
    func handleError(_ error: Error) {
        showErrorAlertSubject.send(error)
        logError(error)
    }

    private func logError(_ error: Error) {
        switch error {
        case let polzzakError as PolzzakError:
            os_log("%@", type: .error, polzzakError.description)
        case let decodingError as DecodingError:
            os_log("%@", type: .error, decodingError.description)
        case let localizedError as LocalizedError where localizedError.errorDescription != nil:
            os_log("%@", type: .error, localizedError.errorDescription!)
        default:
            os_log("%@", type: .error, error.localizedDescription)
        }
    }
}
