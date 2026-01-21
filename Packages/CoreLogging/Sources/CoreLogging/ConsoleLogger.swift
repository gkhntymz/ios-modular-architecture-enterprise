//
//  ConsoleLogger.swift
//  CoreLogging
//
//  Created by Gökhan Taymaz on 21.01.2026.
//

import Foundation

public struct ConsoleLogger: Logger {
    public init() {}

    public func log(_ level: LogLevel, _ message: String, metadata: [String: String] = [:]) {
        let meta: String
        if metadata.isEmpty {
            meta = ""
        } else {
            meta = " " + metadata
                .map { "\($0.key)=\($0.value)" }
                .sorted()
                .joined(separator: " ")
        }

        print("[\(level.rawValue.uppercased())] \(message)\(meta)")
    }
}
