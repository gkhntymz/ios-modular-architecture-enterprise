//
//  AuthServiceMeTests.swift
//  FeatureAuthentication
//
//  Created by Gökhan Taymaz on 23.01.2026.
//

import XCTest
import CoreNetworking
@testable import FeatureAuthentication

final class AuthServiceMeTests: XCTestCase {
    func test_me_401_mapsToSessionExpired() async {
        let client = FailingHTTPClient(error: HTTPClientError.unacceptableStatusCode(401))

        let service = AuthService(
            client: client,
            builder: RequestBuilder(baseURL: URL(string: "https://api.example.com")!),
            networkErrorMapper: AuthNetworkErrorMapper { _ in .unknown }
        )

        do {
            _ = try await service.me()
            XCTFail("Expected to throw")
        } catch let e as AuthError {
            XCTAssertEqual(e, .sessionExpired)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
