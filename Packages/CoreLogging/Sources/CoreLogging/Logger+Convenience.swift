//
//  Logger+Convenience.swift
//  CoreLogging
//
//  Created by Gökhan Taymaz on 28.01.2026.
//

public extension Logger {
    func info(_ message: String, metadata: [String: String] = [:]) {
        log(.info, message, metadata: metadata)
    }

    func error(_ message: String, metadata: [String: String] = [:]) {
        log(.error, message, metadata: metadata)
    }
}
