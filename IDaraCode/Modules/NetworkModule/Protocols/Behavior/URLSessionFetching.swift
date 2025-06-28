import Foundation

protocol URLSessionFetching {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}
