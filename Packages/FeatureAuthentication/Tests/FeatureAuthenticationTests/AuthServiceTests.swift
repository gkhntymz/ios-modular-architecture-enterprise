//
//  AuthServiceTests.swift
//  FeatureAuthentication
//
//  Created by Gökhan Taymaz on 19.01.2026.
//
import XCTest
import CoreNetworking
@testable import FeatureAuthentication

private struct StubHTTPClient: HTTPClient {
    let result: Result<(Data, HTTPURLResponse), Error>

    func data(for request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        try result.get()
    }
}

final class AuthServiceTests: XCTestCase {

    func test_login_401_mapsToInvalidCredentials() async {
        let throwingClient = StubHTTPClient(
            result: .failure(HTTPClientError.unacceptableStatusCode(401))
        )

        let service = AuthService(
            client: throwingClient,
            builder: RequestBuilder(baseURL: URL(string: "https://api.example.com")!),
            networkErrorMapper: AuthNetworkErrorMapper(map: { _ in .unknown })
        )

        do {
            _ = try await service.login(LoginRequest(email: "a@b.com", password: "x"))
            XCTFail("Expected to throw")
        } catch let e as AuthError {
            XCTAssertEqual(e, .invalidCredentials)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
