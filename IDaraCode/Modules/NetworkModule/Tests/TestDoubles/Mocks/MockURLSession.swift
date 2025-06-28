//
//  MockURLSession.swift
//  iOSNativeProject
//
//  Created by Christian Martinez on 18/06/25.
//

import Foundation
@testable import iOSNativeProject

final class MockURLSession: URLSessionFetching {
    var nextData: Data?
    var nextResponse: URLResponse?
    var nextError: Error?

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let err = nextError { throw err }
        return (nextData ?? Data(), nextResponse ?? HTTPURLResponse())
    }
}
