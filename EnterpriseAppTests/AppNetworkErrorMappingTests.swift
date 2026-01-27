//
//  AppNetworkErrorMappingTests.swift
//  EnterpriseApp
//
//  Created by Gökhan Taymaz on 19.01.2026.
//

import XCTest
@testable import EnterpriseApp
@testable import CoreNetworking

final class AppNetworkErrorMappingTests: XCTestCase {

    func test_maps401_toUnauthorized() {
        let error = HTTPClientError.unacceptableStatusCode(401)
        XCTAssertEqual(AppNetworkError.map(error), .unauthorized)
    }

    func test_mapsTimeout_toTimeout() {
        let error = URLError(.timedOut)
        XCTAssertEqual(AppNetworkError.map(error), .timeout)
    }
}
