//
//  Redactor.swift
//  CoreLogging
//
//  Created by Gökhan Taymaz on 21.01.2026.
//

import Foundation

public protocol Redactor: Sendable {
    func redactHeader(name: String, value: String) -> String
}

public struct DefaultRedactor: Redactor {
    private let sensitiveHeaders: Set<String>

    public init(
        sensitiveHeaders: Set<String> = ["authorization", "cookie", "set-cookie"]
    ) {
        self.sensitiveHeaders = Set(sensitiveHeaders.map { $0.lowercased() })
    }

    public func redactHeader(name: String, value: String) -> String {
        if sensitiveHeaders.contains(name.lowercased()) {
            return "<redacted>"
        }
        return value
    }
}
