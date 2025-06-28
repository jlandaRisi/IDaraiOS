//
//  RequestBuilderTests.swift
//  iOSNativeProject
//
//  Created by Christian Martinez on 18/06/25.
//

import XCTest
@testable import iOSNativeProject

final class RequestBuilderTests: XCTestCase {

    func testBuildRequest_generatesURLAndHeaders() throws {
    
        let env = MockEnvironment(baseURL: "https://dev.server.com")

        struct ExtraHeader: HeaderDecorator {
            func decorateHeaders() -> [String : String] { ["X-Custom":"1"] }
        }

        let builder = RequestBuilder(
            environment: env,
            headerStrategies: [ExtraHeader()]
        )

        let ep = Endpoint(
            path: "/test",
            method: .GET,
            body: nil,
            token: nil,
            queryParams: ["q":"1"]
        )

        let request = try builder.buildRequest(for: ep)

        XCTAssertEqual(request.url?.absoluteString,
                       "https://dev.server.com/test?q=1")
        XCTAssertEqual(request.value(forHTTPHeaderField: "X-Custom"), "1")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"),
                       "application/json")
    }
}
