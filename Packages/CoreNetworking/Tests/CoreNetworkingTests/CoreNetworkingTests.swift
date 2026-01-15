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

private final class MockURLProtocol: URLProtocol {
    static var handler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let handler = MockURLProtocol.handler else {
            XCTFail("MockURLProtocol.handler not set")
            return
        }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}

private extension URLSession {
    static func mock(statusCode: Int, data: Data) -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]

        MockURLProtocol.handler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, data)
        }

        return URLSession(configuration: config)
    }
}
