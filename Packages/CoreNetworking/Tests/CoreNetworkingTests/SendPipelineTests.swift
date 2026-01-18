//
//  SendPipelineTests.swift
//  CoreNetworking
//
//  Created by Gökhan Taymaz on 18.01.2026.
//

import XCTest
@testable import CoreNetworking

final class SendPipelineTests: XCTestCase {

    func test_send_decodesJSONResponse() async throws {
        struct Model: Decodable, Equatable { let value: Int }

        let json = #"{"value": 7}"#
        let client = URLSessionHTTPClient(session: .mock(statusCode: 200, data: Data(json.utf8)))
        let builder = RequestBuilder(baseURL: URL(string: "https://api.example.com")!)

        let endpoint = Endpoint<Model>.json(method: .get, path: "/v1/test")

        let model = try await client.send(endpoint, using: builder)
        XCTAssertEqual(model, Model(value: 7))
    }

    func test_send_decodingFailure_mapsToCoreNetworkingError() async {
        struct Model: Decodable { let value: Int }

        let client = URLSessionHTTPClient(session: .mock(statusCode: 200, data: Data("not-json".utf8)))
        let builder = RequestBuilder(baseURL: URL(string: "https://api.example.com")!)
        let endpoint = Endpoint<Model>.json(method: .get, path: "/v1/test")

        do {
            _ = try await client.send(endpoint, using: builder)
            XCTFail("Expected to throw")
        } catch let e as CoreNetworkingError {
            XCTAssertEqual(e, .decodingFailed)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
