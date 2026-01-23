//
//  MetricsSink.swift
//  CoreLogging
//
//  Created by Gökhan Taymaz on 23.01.2026.
//

import Foundation

public protocol MetricsSink: Sendable {
    func increment(_ name: String, tags: [String: String])
    func record(_ name: String, value: Double, unit: String, tags: [String: String])
}

public struct NoopMetricsSink: MetricsSink {
    public init() {}
    public func increment(_ name: String, tags: [String : String]) {}
    public func record(_ name: String, value: Double, unit: String, tags: [String : String]) {}
}
