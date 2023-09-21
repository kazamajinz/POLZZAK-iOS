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
    static let polzzakAPI = OSLog(subsystem: subsystem, category: "polzzakAPI")
}

// TODO: log파라미터를 쓰지 않고 있는데 지우거나 사용하도록 만들기

func os_log(log: OSLog, file: String = #fileID, function: String = #function, errorDescription: String) {
    os.os_log("error at file (%@), at function (%@)\nerror: %@", log: .polzzakAPI, file, function, errorDescription)
}
