//
//  OSLog+extension.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/04.
//

import OSLog

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let ui = OSLog(subsystem: subsystem, category: "UI")
    static let network = OSLog(subsystem: subsystem, category: "Network")
    static let keychain = OSLog(subsystem: subsystem, category: "Keychain")
}
