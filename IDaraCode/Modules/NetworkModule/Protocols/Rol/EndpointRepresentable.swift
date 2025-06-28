import Foundation

protocol EndpointRepresentable {
    var url: URL? { get }
    var path: String? { get }
    var method: HTTPMethod { get }
    var token: String? { get }
    var body: Data? { get }
    var queryParams: [String: String]? { get }
}
