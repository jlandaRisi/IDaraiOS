import Foundation
@testable import iOSNativeProject

final class URLSessionMock: URLSessionProtocol {

    var shouldThrow: Bool = false
    var nextStatusCode: Int = 204

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if shouldThrow { throw URLError(.notConnectedToInternet) }

        let response = HTTPURLResponse(
            url: request.url!,
            statusCode: nextStatusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        return (Data(), response)
    }
}
