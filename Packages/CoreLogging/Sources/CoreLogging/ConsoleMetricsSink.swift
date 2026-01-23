//
//  ConsoleMetricsSink.swift
//  CoreLogging
//
//  Created by Gökhan Taymaz on 23.01.2026.
//

import Foundation

public struct ConsoleMetricsSink: MetricsSink {
    public init() {}

    public func increment(_ name: String, tags: [String : String] = [:]) {
        print("[METRIC] increment \(name) \(format(tags))")
    }

    public func record(_ name: String, value: Double, unit: String, tags: [String : String] = [:]) {
        print("[METRIC] record \(name)=\(value) \(unit) \(format(tags))")
    }

    private func format(_ tags: [String: String]) -> String {
        guard tags.isEmpty == false else { return "" }
        return tags.map { "\($0.key)=\($0.value)" }.sorted().joined(separator: " ")
    }
}
