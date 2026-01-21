//
//  Logger.swift
//  CoreLogging
//
//  Created by Gökhan Taymaz on 21.01.2026.
//

import Foundation

public enum LogLevel: String, Sendable {
    case debug
    case info
    case warning
    case error
}

public protocol Logger: Sendable {
    func log(_ level: LogLevel, _ message: String, metadata: [String: String])
}
