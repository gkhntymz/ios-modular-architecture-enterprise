import XCTest
@testable import CoreNetworking

final class CoreNetworkingTests: XCTestCase {

    func test_unacceptableStatusCode_throws() async {
        let client = URLSessionHTTPClient(session: .mock(statusCode: 500, data: Data()))

        do {
            _ = try await client.data(for: URLRequest(url: URL(string: "https://example.com")!))
            XCTFail("Expected to throw")
        } catch let error as HTTPClientError {
            XCTAssertEqual(error, .unacceptableStatusCode(500))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_success_returnsDataAndResponse() async throws {
        let expected = Data("ok".utf8)
        let client = URLSessionHTTPClient(session: .mock(statusCode: 200, data: expected))

        let (data, response) = try await client.data(for: URLRequest(url: URL(string: "https://example.com")!))

        XCTAssertEqual(data, expected)
        XCTAssertEqual(response.statusCode, 200)
    }
}
