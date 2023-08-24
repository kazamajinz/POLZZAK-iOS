//
//  Task+extension.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/24.
//

import UIKit

extension Task where Success == Never, Failure == Never {
    static func asyncSleep(seconds: Double) async {
        await withCheckedContinuation { continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                continuation.resume()
            }
        }
    }
}
