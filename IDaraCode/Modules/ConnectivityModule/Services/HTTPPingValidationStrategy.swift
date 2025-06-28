import Foundation

public struct HTTPPingValidationStrategy: InternetValidationStrategy {
    private let testURL: URL
    public init(
        testURL: URL = URL(string: "https://www.google.com/generate_204")!
    ) { self.testURL = testURL }

    public func hasInternetAccess(
        using session: URLSessionProtocol = URLSession.shared
    ) async -> Bool {
        var request = URLRequest(url: testURL)
        request.httpMethod = "GET"
        request.timeoutInterval = 5

        do {
            let (_, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse else { return false }
            return (200..<400).contains(http.statusCode)
        } catch {
            return false
        }
    }
}
