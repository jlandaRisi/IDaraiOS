import Foundation

protocol RequestBuilding {
    func buildRequest(for endpoint: Endpoint) throws -> URLRequest
    mutating func addHeaderStrategy(_ strategy: HeaderDecorator)
}
