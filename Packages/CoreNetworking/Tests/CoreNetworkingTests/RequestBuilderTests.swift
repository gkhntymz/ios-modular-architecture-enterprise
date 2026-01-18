//
//  RequestBuilderTests.swift
//  CoreNetworking
//
//  Created by Gökhan Taymaz on 18.01.2026.
//

import XCTest
@testable import CoreNetworking

final class RequestBuilderTests: XCTestCase {
    func test_buildsRequest_withPathQueryHeadersAndBody() throws {
        let baseURL = URL(string: "https://api.example.com")!
        let builder = RequestBuilder(baseURL: baseURL)

        let endpoint = Endpoint<Data>(
            method: .post,
            path: "/v1/login",
            queryItems: [URLQueryItem(name: "a", value: "b")],
            headers: ["X-Test": "1"],
            body: Data("hi".utf8),
            decode: { data, _ in data }
        )

        let req = try builder.makeRequest(for: endpoint)

        XCTAssertEqual(req.httpMethod, "POST")
        XCTAssertEqual(req.value(forHTTPHeaderField: "X-Test"), "1")
        XCTAssertEqual(req.httpBody, Data("hi".utf8))
        XCTAssertEqual(req.url?.absoluteString, "https://api.example.com/v1/login?a=b")
    }
}
