public protocol InternetValidationStrategy {
    func hasInternetAccess(using session: URLSessionProtocol) async -> Bool
}
