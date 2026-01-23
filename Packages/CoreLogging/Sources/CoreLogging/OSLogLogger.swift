//
//  OSLogLogger.swift
//  CoreLogging
//
//  Created by Gökhan Taymaz on 23.01.2026.
//

import Foundation
import OSLog

public struct OSLogLogger: Logger {
    private let logger: os.Logger
    private let minimumLevel: LogLevel

    public init(
        subsystem: String,
        category: String,
        minimumLevel: LogLevel = .info
    ) {
        self.logger = os.Logger(subsystem: subsystem, category: category)
        self.minimumLevel = minimumLevel
    }

    public func log(_ level: LogLevel, _ message: String, metadata: [String : String]) {
        guard level.priority >= minimumLevel.priority else { return }

        let metaString = Self.format(metadata)

        switch level {
        case .debug:
            logger.debug("\(message, privacy: .public) \(metaString, privacy: .private)")
        case .info:
            logger.info("\(message, privacy: .public) \(metaString, privacy: .private)")
        case .warning:
            logger.warning("\(message, privacy: .public) \(metaString, privacy: .private)")
        case .error:
            logger.error("\(message, privacy: .public) \(metaString, privacy: .private)")
        }
    }

    private static func format(_ metadata: [String: String]) -> String {
        guard metadata.isEmpty == false else { return "" }
        return metadata
            .map { "\($0.key)=\($0.value)" }
            .sorted()
            .joined(separator: " ")
    }
}

private extension LogLevel {
    var priority: Int {
        switch self {
        case .debug: return 0
        case .info: return 1
        case .warning: return 2
        case .error: return 3
        }
    }
}
